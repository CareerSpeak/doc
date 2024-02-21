# Introduction

&nbsp;&nbsp;&nbsp;&nbsp;The process of finding a job has undergone significant change due to the quick improvements in technology and changing industry demands. Recognizing the changing environment, our project aims to close the gap between educational institutions and business needs. We think that preparing for placements entails more than just knowing how to respond to interview questions; it also entails being aware of the industry, the labor market, and the abilities that make a person a priceless asset to any firm.

&nbsp;&nbsp;&nbsp;&nbsp;Navigating the challenging environment of job preparation and placement can be challenging in an era of ferocious competition. The modern job market takes more than simply a degree; it also demands a calculated strategy, flawless preparation, and a thorough knowledge of industry dynamics. Our project called 'CareerSpeak: The Placement Preparation App' aims to arm ambitious professionals with the information, abilities, and self-assurance they need to succeed in their professional endeavors.

# Literature Survey

## Resume Parser Using Natural Language Processing Techniques [@resume_parser_nlp]

&nbsp;&nbsp;&nbsp;&nbsp;The paper proposes a model that uses Natural Language Processing (NLP) techniques to extract details and statistics from resumes and rank them based on company preferences and requirements. The model aims to build a job portal where employees and applicants can upload their resumes for specific jobs. The NLP technique is used to parse the necessary information and generate structured resumes. Resumes are also ranked based on the company's skill requirements and the skills mentioned by the applicants. Techniques such as neural networks, CRF, CNN, and segmentation models are used for information extraction from resumes.

&nbsp;&nbsp;&nbsp;&nbsp;The results of the system involve parsing resumes into plain documents, extracting entities, and comparing them with required keywords. The results are presented in the form of pie charts and bar graphs.

## A Keyword Extraction Method Based on learning to Rank [@keyword_extraction_rank]

&nbsp;&nbsp;&nbsp;&nbsp;This paper speaks about TransR method for knowledge graph completion. TransR is an approach that combines graph embedding and rule mining techniques to improve the accuracy of knowledge graph completion. It incorporates both entity and relation embeddings to enhance the performance of link prediction and triple classification tasks. Experimental results on benchmark datasets demonstrate the effectiveness of the TransR approach, outperforming existing methods in terms of evaluation metrics such as mean reciprocal rank and precision at different ranks.

&nbsp;&nbsp;&nbsp;&nbsp;The paper also discusses the limitations of the proposed method and suggests future research directions in the field of knowledge graph completion.

## Automatic Extraction of Usable Information from Unstructured Resumes to Aid Search [@automatic_extraction]

&nbsp;&nbsp;&nbsp;&nbsp;The paper proposes a system for automated resume information extraction using natural language processing (NLP) techniques to support rapid resume search and management. The system is capable of extracting several important fields from free format resumes, including personal information, education, contact telephone number, postal address, languages known, present company, and designation. The proposed system can handle a large variety of resumes in different document formats with a precision of 91% and a recall of 88%.

&nbsp;&nbsp;&nbsp;&nbsp;The system aims to eliminate the need for jobseekers to fill in predefined templates and allows enterprises to extract the required information from any format of resume automatically. The paper highlights the challenges of extracting information from non-standardized resume structures and emphasizes the benefits of an automated system for resume management, including the construction of an electronic resume database and quick processing of resumes. The performance of the system is evaluated using precision and recall metrics on a set of resumes that were not used as reference resumes to build the knowledge base.

## Overview of the Speech Recognition Technology [@speech_recognition_overview]

&nbsp;&nbsp;&nbsp;&nbsp;The paper highlights two key approaches in speech recognition: Hidden Markov Model (HMM) and Artificial Neural Network (ANN). HMM is a statistical model used for fast and accurate speech recognition, while ANN mimics biological nervous systems and offers features like training, parallel processing, rapid judgment, and fault tolerance. Artificial neural networks (ANN) are employed to improve the adaptability and response of speech recognition systems to error inputs. Hidden Markov Models (HMM) are utilized as a statistical model to train the acoustic and voice models in speech recognition systems, leading to accurate and fast recognition results.

&nbsp;&nbsp;&nbsp;&nbsp;The paper addresses challenges in noisy environments, such as variations in pronunciation, speech rate, pitch, and formant changes and suggests the use of new signal analysis and processing approaches. Additionally, representative speech recognition methods, including Dynamic Time Warping (DTW), Vector Quantization (VQ), and Support Vector Machine (SVM), are also mentioned in the paper, but the focus is on HMM and ANN methods.

# Methodology

&nbsp;&nbsp;&nbsp;&nbsp;The system consists of 3 parts-- frontend, middleware and backend. The user interacts with the frontend, which in turn interacts with the middleware to process data and transfer information between the user in the frontend and the machine learning models in the backend.

&nbsp;&nbsp;&nbsp;&nbsp;The system is divided into 3 modules-- Resume Parser module, Mock Interviewer module and Job Recommender module. These modules interact to parse the resume uploaded by the user, extracting the important keywords from the resume, and generating pertinent questions based on the extracted keywords. This system architecture is visualized in [@fig:architecture]

![Architecture of Proposed System](content/images/architecture.pdf){#fig:architecture}

1.	Resume Parser:

    &nbsp;&nbsp;&nbsp;&nbsp;When the user uploads a resume, the pdf document is parsed into text. This parsed data is stored as a string variable in memory [@resume_parser_nlp] [@keyword_extraction_rank], persisting until the user exits the app. The user may choose to have the resume persist as a pdf document, which would be parsed again as required. The whole parsed resume data is given to LanguageTool for grammatical processing. LanguageTool is a Java-based grammar checker that filters the given input text based on predefined rules. These rules can be extended or selectively removed for specific applications.

    &nbsp;&nbsp;&nbsp;&nbsp;LanguageTool provides the matching rule and a suggestion for the rule along with the line and column where the rule match occurs. This output is extracted into the middleware and then visually shown to the user from the frontend with a line underlining the characters at the line and column, a text box showing the rule matched (or a simplified message) and the suggestion.

    ![Flowchart for Grammar Checking Module](content/images/nlp.pdf){#fig:languagetool height=25%}

    &nbsp;&nbsp;&nbsp;&nbsp;As shown [@fig:languagetool], this process loops at each update the user makes to the text to provide real-time grammar-checking.
\

2.	Mock Interviewer:

    &nbsp;&nbsp;&nbsp;&nbsp;This module uses Automatic Speech Recognition (ASR). [@speech_recognition_overview] [@speech_to_text] [@automatic_extraction]

    &nbsp;&nbsp;&nbsp;&nbsp;It uses the WhisperAI Speech to Text pretrained Deep Learning model [@automatic_extraction] from OpenAI to perform analysis on the sentences enunciated by the user to transcribe it into text.

    &nbsp;&nbsp;&nbsp;&nbsp;In the interviewer module, a NoSQL database containing predefined general questions. These would be such that they would apply to all candidates, irrespective of their technical background. Some query processing may also be done to filter the questions based on the user’s employment history.

    &nbsp;&nbsp;&nbsp;&nbsp;The keywords extracted [@resume_parser_nlp] [@keyword_extraction_rank] from the resume play a vital role in fetching questions relating to technologies relevant to the educational and employment history of the user. This will test the technical knowledge of the user. The questions for each keyword or each set of keywords need to be designed manually, so we are limiting them to the fields of Web Development, Machine Learning and Data Science. More categories and questions can be easily added as needed due to the modular nature of the NoSQL database and the keyword extractor.

    &nbsp;&nbsp;&nbsp;&nbsp;The questions also have ideal answers linked to them so that the user can get instant feedback of where the interviewing module found their answer to be lacking. This will also make the module more transparent in its scoring of interviews. Interviews will get a score indicating how close to ideal their answers were. More conditions such as avoiding unclear enunciations[@speech_to_text], etc. may be added as the module is developed.
\

3.	Job Recommender:

    &nbsp;&nbsp;&nbsp;&nbsp;This module is also referred to as Job Recommender System (JRS). [@review_job_recommender]

    &nbsp;&nbsp;&nbsp;&nbsp;The keywords extracted from the resume are used along with the professional and educational qualification fields by the recommender model to provide a list of potentially relevant job opportunities.

    &nbsp;&nbsp;&nbsp;&nbsp;The job listings may be added by the employers individually or a web scraping tool [@job_recommender_skills] may be used for finding the listings. These listings will be stored in a RDBMS so that they can be retrieved by simple SQL queries according to the categories [@resume_parser_nlp] found from the keywords.

    &nbsp;&nbsp;&nbsp;&nbsp;The final list of postings will be forwarded to the frontend, where the user may filter them based on location, salary, and other temporal metrics.


# Limitations

## Job Recommender Systems: A Review [@review_job_recommender]

&nbsp;&nbsp;&nbsp;&nbsp;The classification of hybrid methods in the job recommender system (JRS) literature may still have some overlap and similarity between different classes, which could lead to confusion in understanding the methods used.

## Resume Parser Using Natural Language Processing Techniques [@resume_parser_nlp]

&nbsp;&nbsp;&nbsp;&nbsp;The paper does not address potential biases or limitations in the ranking algorithm used to prioritize resumes based on company preferences and requirements. Ensuring fairness and avoiding bias in the ranking process is crucial.

## Job Recommendation based on Job Seeker Skills: An Empirical Study [@job_recommender_skills]

&nbsp;&nbsp;&nbsp;&nbsp;The paper does not explore the scalability or efficiency of the proposed framework, which could be important considerations for real-world application design.

## Voice Recognition System: Speech-to-Text [@speech_to_text]

&nbsp;&nbsp;&nbsp;&nbsp;The paper does not provide any information about the limitations of the adapted feature extraction technique or the speech recognition approach used in the system. The paper does not discuss any limitations of the low pass filter with finite impulse response or the performance evaluation at signal to noise ratio level.

## Overview of the Speech Recognition Technology [@speech_recognition_overview]

&nbsp;&nbsp;&nbsp;&nbsp;The paper highlights the poor adaptability of speech recognition systems, as they are highly dependent on the environment in which the speech training data is collected. This limits their performance in different environments.

<!--Example of footnote^[A footnote example]

## Code

```{#lst:overview .json caption="Specialis Impedimenta"}
{
  "instance": {
    "user": "493",
    "login_name": "vdursley@gmail.com",
    "email": "vdursley@gmail.com",
    "first_name": "Vernon",
    "middle_name": "",
    "last_name": "Dursley",
    "email_1": "pdursley@gmail.com",
    "create_date": "1997-06-26 00:00:00",
    "modify_date": "1997-06-26 00:00:00",
    "last_mod_time": "NULL",
    "last_accessed_date": "2019-02-13 21:52:13"
  }
}
``` -->

# Conclusion

&nbsp;&nbsp;&nbsp;&nbsp;We have reviewed various use-cases and implementations of natural language processing and keyword extraction in resumes. This review has shown that a system for job recommendation based on keyword detection and mock interview based on automatic speech recognition is feasible. We have also determined the scope for our proposed system, limiting to three job postings and only one language. The approaches to keyword extraction and automatic speech recognition explored in this review show the modularity and flexibly of this technology to adapt it to other domains and use-cases.

&nbsp;&nbsp;&nbsp;&nbsp;Our upcoming research paper based on our implementation of the proposed end-to-end job recommender, resume grammar-checker and mock interviewer app will be utilizing these technologies for easing the placement process.

# References
