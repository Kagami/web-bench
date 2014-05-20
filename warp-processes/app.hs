{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

import GHC.Conc (getNumProcessors)
import Control.Monad (replicateM_)

import Network.Wai
import Network.Socket
import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200)
import System.Posix.Process (forkProcess)
import Data.ByteString.Char8 (pack)
import Blaze.ByteString.Builder (fromByteString)
import qualified Data.ByteString as S

-- XXX: This helper for some reason not available in conduit-extra.
bindPort :: Int -> String -> IO Socket
bindPort p s = do
    sock <- socket AF_INET Stream defaultProtocol
    addr <- inet_addr s
    bindSocket sock $ SockAddrInet (fromIntegral p) addr
    setSocketOption sock NoDelay 1
    setSocketOption sock ReuseAddr 1
    listen sock (max 2048 maxListenQueue)
    return sock

main :: IO ()
main = do
    let port = 8000
    let iface = "127.0.0.1"
    cores <- getNumProcessors
    sock <- bindPort port iface
    let runApp = runSettingsSocket defaultSettings sock app
    replicateM_ (cores - 1) $ forkProcess runApp
    runApp
  where
    body = "Hello, World!"
    bodyLength = pack $ show $ S.length body
    headers = [("Content-Type", "text/plain"), ("Content-Length", bodyLength)]
    app _ = return $ responseBuilder
      status200
      headers
      $ fromByteString body
