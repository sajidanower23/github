-----------------------------------------------------------------------------
-- |
-- License     :  BSD-3-Clause
-- Maintainer  :  Oleg Grenrus <oleg.grenrus@iki.fi>
--
-- The repo invitations API as described on
-- <https://developer.github.com/v3/repos/invitations/>.
module GitHub.Endpoints.Repos.Invitations (
    listInvitationsOnR,
    acceptInvitationFromR,
    listInvitationsForR
    ) where

import GitHub.Data
import GitHub.Internal.Prelude
import Prelude ()

-- | List open invitations of a repository
-- See <https://developer.github.com/v3/repos/invitations/#list-invitations-for-a-repository>
listInvitationsOnR :: Name Owner -> Name Repo -> FetchCount -> Request k (Vector RepoInvitation)
listInvitationsOnR user repo =
    pagedQuery ["repos", toPathPart user, toPathPart repo, "invitations"] []

listInvitationsForR :: FetchCount -> Request k (Vector RepoInvitation)
listInvitationsForR =
    pagedQuery ["user", "repository_invitations"] []

acceptInvitationFromR :: Id RepoInvitation -> Request 'RW RepoInvitation
acceptInvitationFromR invId =
    Command Patch ["user", "repository_invitations", toPathPart invId] mempty
