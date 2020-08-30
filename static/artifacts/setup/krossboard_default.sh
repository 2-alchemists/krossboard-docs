#!/bin/bash
# ------------------------------------------------------------------------ #
# File: krossboard_gcp_install.sh                                          #
# Creation: August 22, 2020                                                #
# Copyright (c) 2020 2Alchemists SAS                                       #
#                                                                          #
# This file is part of Krossboard (https://krossboard.app/).               #
#                                                                          #
# The tool is distributed in the hope that it will be useful,              #
# but WITHOUT ANY WARRANTY; without even the implied warranty of           #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
# Krossboard terms of use: https://krossboard.app/legal/terms-of-use/      #
#--------------------------------------------------------------------------#

export KB_AZURE_PROVIDER_TENANT_ID='9c88e487-60e8-43e5-983b-71133e91669a'
export KB_AZURE_PROVIDER_SUB='89cdfb38-415e-4612-9260-6d095914713d'
export KB_AZURE_CONSUMER_ID='72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0'
export KB_AZURE_CONSUMER_PASS='3R5Cn7CZB5wiVY-2-T2S.G3RLTfJ_cE.15'
export KB_AZURE_VM_SIZE_DEFAULT='Standard_B1ms'
export KB_AZURE_LOCATION_DEFAULT='centralus'
export KB_AWS_AMI_DEFAULT='ami-007d4a8557fef68c5'
export KB_GCP_IMAGE='krossboard-v20200818t1597750044-preview'

declare -A KB_AWS_AMIS
KB_AWS_AMIS["eu-central-1"]='ami-007d4a8557fef68c5'
KB_AWS_AMIS["eu-west-1"]='ami-0d0178c722ba8e95b'
KB_AWS_AMIS["eu-west-2"]='ami-0e4f2d96f1c5c8a98'
KB_AWS_AMIS["us-east-1"]='ami-0afbe840bb49fb3cc'
KB_AWS_AMIS["us-west-1"]='ami-0581c0aca39ce363b'
KB_AWS_AMIS["sa-east-1"]='ami-06ae2e16210f8fbd3'
KB_AWS_AMIS["ap-southeast-1"]='ami-0b0cbef8949f42ca2'
KB_AWS_AMIS["ap-southeast-2"]='ami-0aae673d3e5b2f0ac'
KB_AWS_AMIS["ca-central-1"]=''
KB_AWS_AMIS["me-south-1"]=''