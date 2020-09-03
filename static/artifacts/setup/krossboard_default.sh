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
export KB_AZURE_IMAGE="/subscriptions/${KB_AZURE_PROVIDER_SUB}/resourceGroups/krossboard-release/providers/Microsoft.Compute/galleries/KrossboardRelease/images/Krossboard"

export KB_GCP_IMAGE='krossboard-v20200901t1598988567-c99157f'

declare -A KB_AWS_AMIS
KB_AWS_AMIS["ap-southeast-1"]='ami-029939ebe5cc6623f'
KB_AWS_AMIS["ap-southeast-2"]='ami-02f6ad9441832ddaf'
KB_AWS_AMIS["ca-central-1"]='ami-0d700aa5462414086'
KB_AWS_AMIS["eu-central-1"]='ami-045f4df12a50b158a'
KB_AWS_AMIS["eu-west-1"]='ami-0eff2360db48d5a32'
KB_AWS_AMIS["eu-west-2"]='ami-0c1ffb1d6a5ed82fa'
KB_AWS_AMIS["sa-east-1"]='ami-0932c29080f76d0a2'
KB_AWS_AMIS["us-east-1"]='ami-0e16ecda99564e511'
KB_AWS_AMIS["us-west-1"]='ami-0ee2d470a1116dda4'
