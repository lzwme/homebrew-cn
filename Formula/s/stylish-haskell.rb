class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://ghfast.top/https://github.com/haskell/stylish-haskell/archive/refs/tags/v0.15.1.0.tar.gz"
  sha256 "0187bb335205f6b5c9c78d3fc27deb59ce7122c7eb7429b88971d8cb25d7be51"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "9409346c277a94ec8eeaccf8b6a87ba26ebf340c7ab4d094d63bf5c587910739"
    sha256 cellar: :any, arm64_sequoia: "95834b9abae9b296d5a69e0503da11827aced2d9c3b27f3fff9b3097aa2de4b2"
    sha256 cellar: :any, arm64_sonoma:  "99ec18fd4bc31f757f99c507616d651655213ae17e916019fd5f74703e60bdc2"
    sha256 cellar: :any, sonoma:        "f23166e343e57e6b0fd940e29d0baeab2df8e69e44a0db777115268d6c5b1404"
    sha256 cellar: :any, arm64_linux:   "449d0fd363eee6f2c1b2627f8a6e386bf158b4b3dcdbaf061c381f04edd02c14"
    sha256 cellar: :any, x86_64_linux:  "02a90e71c972ef6c47e696490469a84b892d10eb7c849b8ad060f84658563fb8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
      {-# LANGUAGE ViewPatterns, TemplateHaskell #-}
      {-# LANGUAGE GeneralizedNewtypeDeriving,
                  ViewPatterns,
          ScopedTypeVariables #-}

      module Bad where

      import Control.Applicative ((<$>))
      import System.Directory (doesFileExist)

      import qualified Data.Map as M
      import      Data.Map    ((!), keys, Map)
    HASKELL
    expected = <<~HASKELL
      {-# LANGUAGE GeneralizedNewtypeDeriving #-}
      {-# LANGUAGE ScopedTypeVariables        #-}
      {-# LANGUAGE TemplateHaskell            #-}

      module Bad where

      import           Control.Applicative ((<$>))
      import           System.Directory    (doesFileExist)

      import           Data.Map            (Map, keys, (!))
      import qualified Data.Map            as M
    HASKELL
    # Pass the config explicitly; searching for one walks up to `/`, which the sandbox denies
    (testpath/"config.yaml").write shell_output("#{bin}/stylish-haskell --defaults")

    assert_equal expected, shell_output("#{bin}/stylish-haskell --config config.yaml test.hs")
  end
end