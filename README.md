# 2015_speech
word audio recognition(孤立词语音识别)

It's a project for 2015 fundamentals of speech recognition @ fudan.

Voice tool box，libsvm and Matconvnet has been uesd in my code. I include them in this repsitory.
And all their rights belong to the orignial author.

The project has two parts: training & testing.

audio_record       record data

audio_recog        MFCC+kmeans+LDA/svm

audio_recog_dp     prepare MFCC data for CNN

cascadeface_24net  training CNN model

f24net             CNN structure


audio_test         use svm/LDA model

audio_test_dp      use CNN model
