<div align="center">
    <img src="https://raw.githubusercontent.com/binbashar/bb-devops-tf-aws-kops/master/figures/binbash.png" alt="drawing" width="350"/>
</div>
<div align="right">
  <img src="https://raw.githubusercontent.com/binbashar/bb-devops-tf-aws-kops/master/figures/binbash-leverage-terraform.png"
  alt="leverage" width="230"/>
</div>

# Reference Architecture: Terraform AWS Kubernetes Kops Cluster

## Kops Pre-requisites

### Overview
K8s clusters provisioned by Kops have a number of resources that need to be available before the cluster is created. 
These are Kops pre-requisites and they are defined in the `1-prerequisites` directory which includes all Terraform files used to create/modify these resources.

#### Resulting Solutions Architecture
<div align="center">
  <img src="https://raw.githubusercontent.com/binbashar/bb-devops-tf-aws-kops/master/figures/binbash-aws-kops.png"
alt="leverage" width="1200"/>
</div>

### Why this workflow
The workflow follows the same approach that is used to manage other terraform resources in your AWS accounts. 
E.g. network, identities, and so on.

So we'll use existing AWS resources to create a `cluster-template.yaml` containing all the resource 
IDs that Kops needs to create a Kubernetes cluster. 

Why not directly use Kops CLI to create the K8s cluster as well as the VPC and its other dependencies? 

1. While this is a valid approach, we want to manage all these building blocks independently and be able to 
fully customize any AWS component without having to alter our Kubernetes cluster definitions and vice-versa. 

2. This is a fully declarative coding style approach to manage your infrastructure so being able to declare 
the state of our cluster in YAML files fits **100% as code & GitOps** based approach.

## Kops Cluster Management
The `2-kops` directory includes helper scripts and Terraform files ...

### Overview
Cluster Management via Kops is typically carried out through the kops CLI. In this case, we use a `2-kops` directory that contains a Makefile, Terraform files and other helper scripts that reinforce the workflow we use to create/update/delete the cluster.

### Workflow
This workflow is a little different to the typical Terraform workflows we use. The full workflow goes as follows:
1. Modify files under `1-prerequisites`
  * Mostly before the cluster is created but could be needed afterward
2. Modify `cluster-template.yml`
  * E.g. to add or remove instance groups, upgrade k8s version, etc
3. Run `make cluster-update`
  * Get Terraform outputs from `1-prerequisites`
  * Generate a Kops cluster manifest -- it uses `cluster-template.yml` as a template and the outputs from the point above as replacement values
  * Update Kops state -- it uses the generated Kops cluster manifest in previous point (`cluster.yml`)
  * Generate Kops Terraform file -- this file represents the changes that Kops needs to apply on the cloud provider
4. Run `make plan`
  * To preview any infrastructure changes that Terraform will make
5. Run `make apply`
  * To apply those infrastructure changes
6. Run `make cluster-rolling-update`
  * To determine if Kops needs to trigger some changes to happen right now
  * These are usually changes to the EC2 instances that won't get reflected as they depend on the autoscaling
7. Run `make cluster-rolling-update-yes`
  * To actually make any changes to the cluster masters/nodes happen

The workflow may look complicated at first but generally it boils down to these simplified steps:
1. Modify `cluster-template.yml`
2. Run `make cluste-update`
3. Run `make apply`
4. Run `make cluster-rolling-update-yes`

<div align="center">
  <img src="https://raw.githubusercontent.com/binbashar/bb-devops-tf-aws-kops/master/figures/binbash-aws-kops-tf.png"
alt="leverage" width="1200"/>
</div>

**figure source:** https://medium.com/bench-engineering/deploying-kubernetes-clusters-with-kops-and-terraform-832b89250e8e

## TODO

...

---

# Release Management

## Docker based makefile commands

* <https://cloud.docker.com/u/binbash/repository/docker/binbash/git-release>
* <https://github.com/binbashar/bb-devops-tf-aws-kops/blob/master/Makefile>

Root directory `Makefile` has the automated steps (to be integrated with **CircleCI jobs** []() )

### CircleCi PR auto-release job

<div align="left">
  <img src="https://raw.githubusercontent.com/binbashar/bb-devops-tf-aws-kops/master/figures/circleci.png" alt="leverage-circleci" width="230"/>
</div>

- <https://circleci.com/gh/binbashar/bb-devops-tf-aws-kops>
- **NOTE:** Will only run after merged PR.

### Manual execution from workstation

```
$ make
Available Commands:
 - release-major-with-changelog make changelog-major && git add && git commit && make release-major
 - release-minor-with-changelog make changelog-minor && git add && git commit && make release-minor
 - release-patch-with-changelog make changelog-patch && git add && git commit && make release-patch
