create table contact_info (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    email varchar(255),
    linkedin varchar(255),
    phone varchar(255),
    primary key (id)
) engine=InnoDB;

create table education_matches (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    candidate_degree varchar(255),
    match_level enum ('EXCEEDS','MATCH','MISMATCH'),
    reasoning varchar(4000),
    required_degree varchar(255),
    primary key (id)
) engine=InnoDB;

create table experience_alignments (
    match_percentage float(53),
    max_years_required float(53),
    min_years_required float(53),
    years_candidate float(53),
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    primary key (id)
) engine=InnoDB;

create table experience_ranges (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    max_years varchar(255),
    min_years varchar(255),
    primary key (id)
) engine=InnoDB;

create table personal_info (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    email varchar(255),
    first_name varchar(255),
    last_name varchar(255),
    location varchar(255),
    phone varchar(255),
    primary key (id)
) engine=InnoDB;

create table users (
    is_enabled bit not null,
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    email varchar(255) not null unique,
    first_name varchar(255) not null,
    last_name varchar(255) not null,
    password varchar(255) not null,
    username varchar(255) not null unique,
    rh_approval_status enum ('APPROVED','PENDING','REJECTED') not null,
    role enum ('ADMIN','CANDIDATE','HR') not null,
    primary key (id)
) engine=InnoDB;

create table match_scores (
    overall_score float(53),
    created_at datetime(6) not null,
    education_match_id bigint unique references education_matches (id),
    experience_alignment_id bigint unique references experience_alignments (id),
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    recommendation varchar(4000),
    reasoning varchar(8000),
    primary key (id)
) engine=InnoDB;

create table profile_data (
    contact_info_id bigint unique references contact_info (id),
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    personal_info_id bigint unique references personal_info (id),
    updated_at datetime(6) not null,
    primary key (id)
) engine=InnoDB;

create table hr_persons (
    id bigint not null references users (id),
    primary key (id)
) engine=InnoDB;

create table job_offers (
    created_at datetime(6) not null,
    created_by_id bigint not null references users (id),
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    is_deleted boolean default false not null,
    status varchar(32) not null,
    jd_request_id varchar(255),
    title varchar(255) not null,
    raw_text LONGTEXT not null,
    primary key (id)
) engine=InnoDB;

create table refresh_tokens (
    revoked bit not null,
    created_at datetime(6) not null,
    expires_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    user_id bigint not null references users (id),
    token varchar(768) not null unique,
    primary key (id)
) engine=InnoDB;

create table admins (
    id bigint not null references users (id),
    primary key (id)
) engine=InnoDB;

create table candidates (
    id bigint not null references users (id),
    primary key (id)
) engine=InnoDB;

create table verification_codes (
    used bit not null,
    created_at datetime(6) not null,
    expires_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    user_id bigint not null references users (id),
    code varchar(10) not null,
    primary key (id)
) engine=InnoDB;

create table password_reset_tokens (
    token varchar(6) not null,
    created_at datetime(6) not null,
    expiry_date datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    user_id bigint not null unique references users (id),
    primary key (id)
) engine=InnoDB;

create table missing_skills (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    match_score_id bigint not null references match_scores (id),
    updated_at datetime(6) not null,
    importance varchar(255),
    skill_name varchar(255),
    primary key (id)
) engine=InnoDB;

create table matched_skills (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    match_score_id bigint not null references match_scores (id),
    updated_at datetime(6) not null,
    name varchar(255),
    primary key (id)
) engine=InnoDB;

create table languages (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    profile_data_id bigint not null references profile_data (id),
    updated_at datetime(6) not null,
    language varchar(255),
    level varchar(255),
    primary key (id)
) engine=InnoDB;

create table hobbies (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    profile_data_id bigint not null references profile_data (id),
    updated_at datetime(6) not null,
    name varchar(255),
    primary key (id)
) engine=InnoDB;

create table skills (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    profile_data_id bigint not null references profile_data (id),
    updated_at datetime(6) not null,
    category varchar(255),
    name varchar(255),
    primary key (id)
) engine=InnoDB;

create table experiences (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    profile_data_id bigint not null references profile_data (id),
    updated_at datetime(6) not null,
    description varchar(4000),
    company varchar(255),
    end_date varchar(255),
    start_date varchar(255),
    title varchar(255),
    primary key (id)
) engine=InnoDB;

create table normalized_skills (
    years_experience float(53),
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    profile_data_id bigint not null references profile_data (id),
    updated_at datetime(6) not null,
    category varchar(255),
    normalized_name varchar(255),
    original_name varchar(255),
    proficiency_level varchar(255),
    primary key (id)
) engine=InnoDB;

create table educations (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    profile_data_id bigint not null references profile_data (id),
    updated_at datetime(6) not null,
    degree varchar(255),
    end_date varchar(255),
    honors varchar(255),
    institution varchar(255),
    start_date varchar(255),
    primary key (id)
) engine=InnoDB;

create table certificates (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    profile_data_id bigint not null references profile_data (id),
    updated_at datetime(6) not null,
    date varchar(255),
    issuer varchar(255),
    name varchar(255),
    primary key (id)
) engine=InnoDB;

create table structured_jds (
    created_at datetime(6) not null,
    experience_range_id bigint unique references experience_ranges (id),
    id bigint not null auto_increment,
    job_offer_id bigint unique references job_offers (id),
    updated_at datetime(6) not null,
    company_name varchar(255),
    employment_type varchar(255),
    title varchar(255),
    work_location varchar(255),
    primary key (id)
) engine=InnoDB;

create table cvs (
    candidate_id bigint not null references candidates (id),
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    job_offer_id bigint not null references job_offers (id),
    profile_data_id bigint unique references profile_data (id),
    updated_at datetime(6) not null,
    upload_date datetime(6) not null,
    file_url varchar(255) not null,
    ocr_payload_json longtext,
    raw_text longtext,
    status enum ('EVALUATED','FAILED','OCR_DONE','SENT_FOR_EVALUATION','UPLOADED') not null,
    primary key (id)
) engine=InnoDB;

create table required_skills (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    structured_jd_id bigint not null references structured_jds (id),
    updated_at datetime(6) not null,
    name varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table preferred_skills (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    structured_jd_id bigint not null references structured_jds (id),
    updated_at datetime(6) not null,
    name varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table qualifications (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    structured_jd_id bigint not null references structured_jds (id),
    updated_at datetime(6) not null,
    description varchar(2000) not null,
    primary key (id)
) engine=InnoDB;

create table responsibilities (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    structured_jd_id bigint not null references structured_jds (id),
    updated_at datetime(6) not null,
    description varchar(2000) not null,
    primary key (id)
) engine=InnoDB;

create table candidate_evaluations (
    created_at datetime(6) not null,
    cv_id bigint unique references cvs (id),
    id bigint not null auto_increment,
    match_score_id bigint unique references match_scores (id),
    structured_jd_id bigint references structured_jds (id),
    updated_at datetime(6) not null,
    status enum ('FAILED','SCORED','WAITING') not null,
    primary key (id)
) engine=InnoDB;

create table technical_questions (
    bluff_indicator bit,
    candidate_evaluation_id bigint not null references candidate_evaluations (id),
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    expected_answer varchar(4000),
    question varchar(4000),
    difficulty varchar(255),
    skill_area varchar(255),
    primary key (id)
) engine=InnoDB;

create table hr_questions (
    candidate_evaluation_id bigint not null references candidate_evaluations (id),
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    evaluation_criteria varchar(4000),
    psychological_intent varchar(4000),
    question varchar(4000),
    primary key (id)
) engine=InnoDB;

create table follow_up_questions (
    created_at datetime(6) not null,
    id bigint not null auto_increment,
    technical_question_id bigint not null references technical_questions (id),
    updated_at datetime(6) not null,
    text varchar(4000),
    primary key (id)
) engine=InnoDB;

create table follow_up_probes (
    created_at datetime(6) not null,
    hr_question_id bigint not null references hr_questions (id),
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    text varchar(4000),
    primary key (id)
) engine=InnoDB;

create table red_flags (
    created_at datetime(6) not null,
    hr_question_id bigint not null references hr_questions (id),
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    text varchar(4000),
    primary key (id)
) engine=InnoDB;

create table ideal_response_indicators (
    created_at datetime(6) not null,
    hr_question_id bigint not null references hr_questions (id),
    id bigint not null auto_increment,
    updated_at datetime(6) not null,
    text varchar(4000),
    primary key (id)
) engine=InnoDB;
