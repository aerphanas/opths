module Main where

import System.Console.GetOpt
import System.Environment
import Data.Maybe ( fromMaybe )

data Flag = Verbose
          | Version
          | Input String
          | Output String
          | LibDir String
          deriving Show

options :: [OptDescr Flag]
options = [ Option ['v']     ["verbose"] (NoArg Verbose)       "chatty output on stderr"
          , Option ['V','?'] ["version"] (NoArg Version)       "show version number"
          , Option ['o']     ["output"]  (OptArg outp "FILE")  "output FILE"
          , Option ['c']     []          (OptArg inp  "FILE")  "input FILE"
          , Option ['L']     ["libdir"]  (ReqArg LibDir "DIR") "library directory"
          ]

outp :: Maybe String -> Flag
outp = Output . fromMaybe "stdout"

inp :: Maybe String -> Flag
inp  = Input  . fromMaybe "stdin"

compilerOpts :: [String] -> Either String ([Flag], [String])
compilerOpts argv = case getOpt Permute options argv of
                      (o, n, []) -> Right (o, n)
                      (_, _, errs) -> Left $ concat errs ++ usageInfo header options
                      where header = "Usage: opths [OPTION...] files..."

main :: IO ()
main = do
  args <- getArgs
  case compilerOpts args of
    Left err -> putStrLn err
    Right (flags, files) -> do
      print flags
      print files
