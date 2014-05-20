{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.ByteString.Char8 (pack)
import Blaze.ByteString.Builder (fromByteString)
import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200)
import qualified Data.ByteString as S

main :: IO ()
main = runSettings settings $ const $ return $ responseBuilder
    status200
    headers
    $ fromByteString body
  where
    settings = setHost "127.0.0.1" $ setPort 8000 $ defaultSettings
    body = "Hello, World!"
    bodyLength = pack $ show $ S.length body
    headers = [("Content-Type", "text/plain"), ("Content-Length", bodyLength)]
