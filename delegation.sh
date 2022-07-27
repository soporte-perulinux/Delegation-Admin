#!/bin/bash

DOMAIN="${1}"
ACCOUNT="${2}"
ZMPROV="/opt/zimbra/bin/zmprov"

if [ -z "$DOMAIN" ]; then
  echo -e "Parameters are missing..
  \$1 : domain
  \$2 : user_delegate\n"
  exit
fi

basic(){
$ZMPROV ma $ACCOUNT zimbraIsDelegatedAdminAccount TRUE
$ZMPROV ma $ACCOUNT zimbraAdminConsoleUIComponents accountListView zimbraAdminConsoleUIComponents DLListView zimbraAdminConsoleUIComponents aliasListView zimbraAdminConsoleUIComponents resourceListView zimbraAdminConsoleUIComponents domainListView

$ZMPROV grr domain $DOMAIN usr $ACCOUNT +createAccount
$ZMPROV grr domain $DOMAIN usr $ACCOUNT +createAlias
$ZMPROV grr domain $DOMAIN usr $ACCOUNT +createCalendarResource
$ZMPROV grr domain $DOMAIN usr $ACCOUNT +createDistributionList
$ZMPROV grr domain $DOMAIN usr $ACCOUNT +deleteAlias
$ZMPROV grr domain $DOMAIN usr $ACCOUNT +listDomain
$ZMPROV grr domain $DOMAIN usr $ACCOUNT +domainAdminRights
$ZMPROV grr domain $DOMAIN usr $ACCOUNT set.account.zimbraAccountStatus
$ZMPROV grr domain $DOMAIN usr $ACCOUNT set.account.sn
$ZMPROV grr domain $DOMAIN usr $ACCOUNT set.account.displayName
$ZMPROV grr domain $DOMAIN usr $ACCOUNT set.account.zimbraPasswordMustChange

$ZMPROV grr domain $DOMAIN usr $ACCOUNT -set.account.zimbraMailQuota
$ZMPROV grr domain $DOMAIN usr $ACCOUNT -set.account.zimbraCOSId
$ZMPROV grr domain $DOMAIN usr $ACCOUNT -set.domain.zimbraDomainDefaultCOSId


$ZMPROV grr account $ACCOUNT usr $ACCOUNT +deleteAccount
$ZMPROV grr account $ACCOUNT usr $ACCOUNT +getAccountInfo
$ZMPROV grr account $ACCOUNT usr $ACCOUNT +getAccountMembership
$ZMPROV grr account $ACCOUNT usr $ACCOUNT +getMailboxInfo
$ZMPROV grr account $ACCOUNT usr $ACCOUNT +listAccount
$ZMPROV grr account $ACCOUNT usr $ACCOUNT +removeAccountAlias
$ZMPROV grr account $ACCOUNT usr $ACCOUNT +renameAccount
$ZMPROV grr account $ACCOUNT usr $ACCOUNT +setAccountPassword
$ZMPROV grr account $ACCOUNT usr $ACCOUNT +viewAccountAdminUI
}

viewMailAccount(){
$ZMPROV grr global usr $ACCOUNT +listZimlet
$ZMPROV grr global usr $ACCOUNT +modifyZimlet
$ZMPROV grr global usr $ACCOUNT +adminLoginAs
}
viewDomainQuotaUsage(){
$ZMPROV grr domain $DOMAIN usr $ACCOUNT +getDomainQuotaUsage
}
viewAllMailQueue(){
$ZMPROV grr global usr $ACCOUNT +adminConsoleMailQueueRights
}
configQuotaAccount(){
$ZMPROV ma $ACCOUNT zimbraDomainAdminMaxMailQuota 0
$ZMPROV grr account $ACCOUNT usr $ACCOUNT +configureQuota
}
notManageZimletsAccount(){
#$ZMPROV grr global usr $ACCOUNT -adminConsoleZimletRights
$ZMPROV grr domain $DOMAIN usr $ACCOUNT -setAdminConsoleAccountsZimletsTab
$ZMPROV grr domain $DOMAIN usr $ACCOUNT -viewDomainAdminConsoleAccountsZimletsTab
$ZMPROV grr domain $DOMAIN usr $ACCOUNT -viewAdminConsoleDomainZimletsTab
}

#=======================
main(){
basic
viewMailAccount
viewDomainQuotaUsage
notManageZimletsAccount
#viewAllMailQueue
#configQuotaAccount
}

#=======================
main

#=======================
# Get Rigths (https://wiki.zimbra.com/wiki/UmaT-Implementing-Delegated-Administration)
# zmprov gg -g usr admin@domain.com | grep ^global | awk '{print $1,$3,$5,$6}'
# zmprov gg -g usr admin@domain.com | grep ^domain | awk '{print $1,$3,$4,$6,$7}'
