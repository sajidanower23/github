-----------------------------------------------------------------------------
-- |
-- License     :  BSD-3-Clause
-- Maintainer  :  Oleg Grenrus <oleg.grenrus@iki.fi>
--
module GitHub.Auth (
    Auth (..),
    AuthMethod,
    endpoint,
    setAuthRequest
    ) where

import GitHub.Internal.Prelude
import Prelude ()

import qualified Data.ByteString     as BS
import qualified Network.HTTP.Client as HTTP

type Token = BS.ByteString

-- | The Github auth data type
data Auth
    = BasicAuth BS.ByteString BS.ByteString  -- ^ Username and password
    | OAuth Token                            -- ^ OAuth token
    | EnterpriseOAuth Text Token             -- ^ Custom endpoint and OAuth token
    deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Auth where rnf = genericRnf
instance Binary Auth
instance Hashable Auth

-- | A type class for different authentication methods
class AuthMethod a where
    -- | Custom API endpoint without trailing slash
    endpoint       :: a -> Maybe Text
    -- | A function which sets authorisation on an HTTP request
    setAuthRequest :: a -> HTTP.Request -> HTTP.Request

instance AuthMethod Auth where
    endpoint (BasicAuth _ _)       = Nothing
    endpoint (OAuth _)             = Nothing
    endpoint (EnterpriseOAuth e _) = Just e

    setAuthRequest (BasicAuth u p)       = HTTP.applyBasicAuth u p
    setAuthRequest (OAuth t)             = setAuthHeader $ "token " <> t
    setAuthRequest (EnterpriseOAuth _ t) = setAuthHeader $ "token " <> t

setAuthHeader :: BS.ByteString -> HTTP.Request -> HTTP.Request
setAuthHeader auth req =
    req { HTTP.requestHeaders = ("Authorization", auth) : HTTP.requestHeaders req }
