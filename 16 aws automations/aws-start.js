import AWS from "@aws-sdk/client-s3";

// AWS.config.update({
//   region: "ap-south-1",
// });

const ec2 = new AWS.EC2();

const stop = async () => {
  const result = await ec2
    .stopInstances({
      InstanceIds: ["i-044bbe8b6bf845a2e"],
    })
    .promise();

  console.log(result);
};

stop();
