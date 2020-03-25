#!/bin/bash
# $1 domain
# $2 email

if [ -z "$2" ]; then
   echo -e "Parameters are missing..
\$1 : domain
\$2 : user_delegate\n"
  exit
fi

#DOCUMENTATION:  /opt/zimbra/docs/* | /opt/zimbra/docs/rights.txt
basic(){
/opt/zimbra/bin/zmprov ma $2 zimbraIsDelegatedAdminAccount TRUE
/opt/zimbra/bin/zmprov ma $2 zimbraAdminConsoleUIComponents cartBlancheUI zimbraAdminConsoleUIComponents domainListView zimbraAdminConsoleUIComponents accountListView zimbraAdminConsoleUIComponents DLListView
/opt/zimbra/bin/zmprov ma $2 zimbraDomainAdminMaxMailQuota 0

/opt/zimbra/bin/zmprov grr global usr $2 +listZimlet
/opt/zimbra/bin/zmprov grr global usr $2 +modifyZimlet
/opt/zimbra/bin/zmprov grr global usr $2 +adminLoginAs

/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 +createAccount
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 +createAlias
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 +createCalendarResource
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 +createDistributionList
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 +deleteAlias
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 +listDomain
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 +domainAdminRights
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 +configureQuota
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 set.account.zimbraAccountStatus
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 set.account.sn
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 set.account.displayName
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 set.account.zimbraPasswordMustChange
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 getDomainQuotaUsage
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +deleteAccount
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +getAccountInfo
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +getAccountMembership
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +getMailboxInfo
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +listAccount
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +removeAccountAlias
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +renameAccount
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +setAccountPassword
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +viewAccountAdminUI
/opt/zimbra/bin/zmprov grantRight account $2 usr $2 +configureQuota
}
viewDomainQuotaUsage(){
/opt/zimbra/bin/zmprov grantRight domain $1 usr $2 +getDomainQuotaUsage
}
viewAllMailQueue(){
/opt/zimbra/bin/zmprov grr global usr $2 +adminConsoleMailQueueRights
}

#=======================
main(){
basic
viewDomainQuotaUsage
#viewAllMailQueue
}

main
