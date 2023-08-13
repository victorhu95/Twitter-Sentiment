# Twitter-Sentiment

Sentiment analysis of social media

First, deploy an Amazon EC2 instance in an Amazon VPC that ingests tweets from Twitter.

Next, create an Amazon Kinesis Data Firehose delivery stream that loads the streaming tweets into the raw prefix in the solution's S3 bucket.

S3 invokes a Lambda function to analyze the raw tweets using Amazon Translate to translate non-English tweets into English, and Amazon Comprehend to use natural language-processing (NLP) to perform entity extraction and sentiment analysis.

A second Kinesis Data Firehose delivery stream loads the translated tweets and sentiment values into the sentiment prefix in the S3 bucket. A third delivery stream loads entities in the entities prefix in the S3 bucket.

This architecture also deploys a data lake that includes AWS Glue for data transformation, Amazon Athena for data analysis, and Amazon QuickSight for data visualization. AWS Glue Data Catalog contains a logical database used to organize the tables for the data in S3. Athena uses these table definitions to query the data stored in S3 and return the information to an Amazon QuickSight dashboard.

![image](https://github.com/victorhu95/Twitter-Sentiment/assets/44851564/4a248ba2-8af3-471a-92e2-672b45612cd2)
