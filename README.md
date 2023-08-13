# Twitter-Sentiment

To gauge public sentiment surrounding food delivery services, real-time tweets are harvested using the Twitter API and processed via Amazon AWS. Initially, an Amazon EC2 instance fetches tweets, which are directed into an S3 bucket via Amazon Kinesis Data Firehose. These raw tweets undergo sentiment analysis and translation through a Lambda function, leveraging Amazon Translate and Amazon Comprehend. The processed data, segmented into sentiment and entities, resides in dedicated prefixes within the S3 bucket. This data infrastructure integrates with AWS Glue for transformations, Amazon Athena for querying, and Amazon QuickSight for visualization, providing a dynamic and insightful dashboard on public sentiment.

![image](https://github.com/victorhu95/Twitter-Sentiment/assets/44851564/4a248ba2-8af3-471a-92e2-672b45612cd2)
