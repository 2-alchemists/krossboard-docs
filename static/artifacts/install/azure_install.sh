#!/bin/bash

echo "sign in to Azure"
az login

TENANT_ID=$(az account show --query "tenantId" | cut -d'"' -f2)
SUBSCRIPTION_ID=$(az account show --query id | cut -d'"' -f2)
echo -e "TENANT_ID: $TENANT_ID\nSUBSCRIPTION_ID: $SUBSCRIPTION_ID"

echo "Consent to access Krossboard Shared image gallery on Azure"
xdg-open "https://login.microsoftonline.com/$TENANT_ID/oauth2/authorize?client_id=72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0&response_type=code&redirect_uri=https%3A%2F%2Fwww.microsoft.com%2F"
