-----------------------------------------------------------------------------
-- |
-- License     :  BSD-3-Clause
-- Maintainer  :  Oleg Grenrus <oleg.grenrus@iki.fi>
--
-- The repo collaborators API as described on
-- <http://developer.github.com/v3/repos/collaborators/>.
module GitHub.Endpoints.Repos.Collaborators (
    collaboratorsOn,
    collaboratorsOn',
    collaboratorsOnR,
    isCollaboratorOn,
    isCollaboratorOnR,
    addCollaborator,
    addCollaboratorR,
    module GitHub.Data,
    ) where

import           GitHub.Data
import           GitHub.Internal.Prelude
import           GitHub.Request
import           Prelude                 ()

-- | All the users who have collaborated on a repo.
--
-- > collaboratorsOn "thoughtbot" "paperclip"
collaboratorsOn :: Name Owner -> Name Repo -> IO (Either Error (Vector SimpleUser))
collaboratorsOn = collaboratorsOn' Nothing

-- | All the users who have collaborated on a repo.
-- With authentication.
collaboratorsOn' :: Maybe Auth -> Name Owner -> Name Repo -> IO (Either Error (Vector SimpleUser))
collaboratorsOn' auth user repo =
    executeRequestMaybe auth $ collaboratorsOnR user repo FetchAll

-- | List collaborators.
-- See <https://developer.github.com/v3/repos/collaborators/#list-collaborators>
collaboratorsOnR :: Name Owner -> Name Repo -> FetchCount -> Request k (Vector SimpleUser)
collaboratorsOnR user repo =
    pagedQuery ["repos", toPathPart user, toPathPart repo, "collaborators"] []

-- | Whether the user is collaborating on a repo. Takes the user in question,
-- the user who owns the repo, and the repo name.
--
-- > isCollaboratorOn Nothing "mike-burns" "thoughtbot" "paperclip"
-- > isCollaboratorOn Nothing "johnson" "thoughtbot" "paperclip"
isCollaboratorOn
    :: Maybe Auth
    -> Name Owner  -- ^ Repository owner
    -> Name Repo         -- ^ Repository name
    -> Name User         -- ^ Collaborator?
    -> IO (Either Error Bool)
isCollaboratorOn auth user repo coll =
    executeRequestMaybe auth $ isCollaboratorOnR user repo coll

-- | Check if a user is a collaborator.
-- See <https://developer.github.com/v3/repos/collaborators/#check-if-a-user-is-a-collaborator>
isCollaboratorOnR
    :: Name Owner  -- ^ Repository owner
    -> Name Repo         -- ^ Repository name
    -> Name User         -- ^ Collaborator?
    -> Request k Bool
isCollaboratorOnR user repo coll = StatusQuery statusOnlyOk $
    Query ["repos", toPathPart user, toPathPart repo, "collaborators", toPathPart coll] []

addCollaborator
    :: Auth
    -> Name Owner        -- ^ Repository owner
    -> Name Repo         -- ^ Repository name
    -> Name User         -- ^ Collaborator to add
    -> IO (Either Error Invitation)
addCollaborator auth owner repo coll =
    executeRequest auth $ addCollaboratorR owner repo coll

addCollaboratorR
    :: Name Owner        -- ^ Repository owner
    -> Name Repo         -- ^ Repository name
    -> Name User         -- ^ Collaborator to add
    -> Request 'RW Invitation
addCollaboratorR owner repo coll =
    command Put ["repos", toPathPart owner, toPathPart repo, "collaborators", toPathPart coll] mempty
-- /repos/:owner/:repo/collaborators/:username
