import * as awsx from "@pulumi/awsx";
import * as eks from "@pulumi/eks";

const vpc = new awsx.ec2.Vpc("vpc", {
  cidrBlock: "10.0.0.0/16"
});


const cluster = new eks.Cluster("cluster", {
  vpcId: vpc.vpcId ,
  subnetIds: vpc.publicSubnetIds,
  instanceType: "t2.medium",
});

exports.kubeconfig = cluster.kubeconfig;
