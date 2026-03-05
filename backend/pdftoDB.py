import pdfplumber
import os
from sqlalchemy.orm import Session
from database import SessionLocal, engine
import models

# 1. 데이터베이스 세션 생성
def get_db_session():
    # models.py에 정의된 테이블이 없으면 생성
    models.Base.metadata.create_all(bind=engine)
    return SessionLocal()

# 2. PDF에서 학과/학부 정보 추출
def extract_departments_from_pdf(file_path):
    departments = set()
    
    with pdfplumber.open(file_path) as pdf:
        for page in pdf.pages:
            text = page.extract_text()
            if not text:
                continue
            
            lines = text.split('\n')
            # 첫 번째 줄: '전공 강의시간표', 두 번째 줄: 학부/학과명
            if len(lines) >= 2:
                line_text = lines[1].strip()
                # '전공 강의시간표', '대학전체' 등 제외
                if line_text and line_text != '전공 강의시간표' and line_text != '대학전체':
                    # 공백으로 분리 (예: "사회과학대학 아동가족복지학과")
                    parts = line_text.split()
                    if len(parts) >= 2:
                        college = parts[0]
                        dept = " ".join(parts[1:])
                    else:
                        college = "미지정"
                        dept = line_text
                    departments.add((college, dept))
                    
    return departments

# 3. 메인 실행 로직
def main():
    db = get_db_session()
    
    # 처리할 PDF 파일 리스트
    pdf_files = [
        '2026_1_lecture_07_01.pdf', '2026_1_lecture_07_04.pdf',
        '2026_1_lecture_07_05.pdf', '2026_1_lecture_07_06.pdf',
        '2026_1_lecture_07_07.pdf'
    ]
    
    all_departments = set()

    print("데이터 추출 중...")
    for file in pdf_files:
        if os.path.exists(file):
            found = extract_departments_from_pdf(file)
            all_departments.update(found)
            print(f"[{file}] 추출 완료: {len(found)}개 학과")

    # 4. DB에 저장 (college, office_tel은 NULL로 저장)
    print("\nDB 저장 중...")
    inserted = 0
    for college_name, dept_name in sorted(all_departments, key=lambda x: x[1]):
        # 이미 존재하는지 확인 (중복 방지)
        existing = db.query(models.Depart).filter(models.Depart.depart == dept_name).first()
        
        if not existing:
            new_dept = models.Depart(
                college=college_name,      # PDF에서 추출한 단과대학 정보
                depart=dept_name,
                office_tel="000-0000" # PDF에서 추출 불가 시 기본값
            )
            db.add(new_dept)
            inserted += 1

    db.commit()
    print(f"총 {inserted}개 학과 저장 완료")
    
    # 결과 확인
    departments = db.query(models.Depart).all()
    print("\n--- 저장된 학과 목록 ---")
    print(f"{'dept_no':<10} {'college':<15} {'depart':<40} {'office_tel':<15}")
    print("-" * 80)
    for dept in departments:
        print(f"{dept.dept_no:<10} {dept.college:<15} {dept.depart:<40} {dept.office_tel:<15}")
        
    db.close()

if __name__ == "__main__":
    main()