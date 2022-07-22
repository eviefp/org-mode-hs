-- |

module Org.Parser
  ( defaultOrgOptions
  , OrgOptions
  , parseOrg
  , parseOrgIO
  ) where
import Org.Parser.Document
import Org.Parser.State
import Org.Parser.Definitions

parseOrg :: OrgOptions -> FilePath -> Text -> Either OrgParseError OrgDocument
parseOrg opt = parse (evalStateT orgDocument defaultState { orgStateOptions = opt })

parseOrgIO :: MonadIO m => OrgOptions -> FilePath -> m OrgDocument
parseOrgIO opt fp = do
  text <- readFileBS fp
  case parseOrg opt fp $ decodeUtf8 text of
    Left e -> error . toText $ errorBundlePretty e
    Right d -> pure d
