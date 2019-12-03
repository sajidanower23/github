-----------------------------------------------------------------------------
-- |
-- License     :  BSD-3-Clause
-- Maintainer  :  Oleg Grenrus <oleg.grenrus@iki.fi>
--
-- The repo watching API as described on
-- <https://developer.github.com/v3/activity/watching/>.
module GitHub.Endpoints.Activity.Watching (
    watchersForR,
    reposWatchedByR,
    module GitHub.Data,
) where

import GitHub.Auth
import GitHub.Data
import GitHub.Internal.Prelude
import Prelude ()

-- | List watchers.
-- See <https://developer.github.com/v3/activity/watching/#list-watchers>
watchersForR :: Name Owner -> Name Repo -> FetchCount -> Request k (Vector SimpleUser)
watchersForR user repo limit =
    pagedQuery ["repos", toPathPart user, toPathPart repo, "watchers"] [] limit

-- | List repositories being watched.
-- See <https://developer.github.com/v3/activity/watching/#list-repositories-being-watched>
reposWatchedByR :: Name Owner -> FetchCount -> Request k (Vector Repo)
reposWatchedByR user =
    pagedQuery ["users", toPathPart user, "subscriptions"] []
