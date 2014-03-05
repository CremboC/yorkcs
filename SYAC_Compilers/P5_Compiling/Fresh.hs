-- By Matt Naylor

-- This module extends the Haskell language with an impure function
--
--   fresh :: () -> String
--
-- that returns fresh name (a unqiue number prefixed with "$") every
-- time it is called.  This modules uses advanced Haskell features to
-- provide what might be considered a very simple function! But you
-- do NOT need to understand how it works.

module Fresh(fresh) where

import Data.IORef
import System.IO.Unsafe

{-# NOINLINE global #-}
global :: IORef Integer
global = unsafePerformIO(newIORef(0))

{-# NOINLINE fresh #-}
fresh :: () -> String
fresh() =
  unsafePerformIO (
    do { n <- readIORef(global)
       ; writeIORef global (n+1)
       ; return("$" ++ show(n))
       }
  )
