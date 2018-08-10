{-|
Module      : TestAppsCPPMain
Description : Main driver for lol-apps tests with CPP.
Copyright   : (c) Eric Crockett, 2011-2017
                  Chris Peikert, 2011-2017
License     : GPL-3
Maintainer  : ecrockett0@email.com
Stability   : experimental
Portability : POSIX

Main driver for lol-apps tests with CPP.
-}

module TestAppsCPPMain where

import Crypto.Lol                       (TrivGad)
import Crypto.Lol.Applications.Tests
import Crypto.Lol.Cyclotomic.Tensor.CPP
import Data.Proxy

import Test.Framework

main :: IO ()
main =
  flip defaultMainWithArgs ["--threads=1","--maximum-generated-tests=100"] $
  defaultAppsTests (Proxy::Proxy CT) (Proxy::Proxy TrivGad)
