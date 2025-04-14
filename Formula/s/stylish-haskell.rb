class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https:github.comhaskellstylish-haskell"
  url "https:github.comhaskellstylish-haskellarchiverefstagsv0.15.0.0.tar.gz"
  sha256 "54e6cc986ab4e3c0be278af9f30b53c5fa99ed8a9bd88cae9b1e0a0be3dbfe52"
  license "BSD-3-Clause"
  head "https:github.comhaskellstylish-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8fea17aad9b3cb52454ff389a9c88498492c12cef98daa1f6370ae474e3d76d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1520fe28b0210934dade571784efebc3e5ce69d184c77d6f53a633bf289cda4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63698e7f64b689498ae19c0c60ee892efb559f74e4ddb85c0fdc1f8898fdc6cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fef1763160ed9924aeca285c2d884f02d4470f59fc1ca4ad1ff20f0f5b1ad77"
    sha256 cellar: :any_skip_relocation, ventura:       "7e3853a872a52197a4b5f572a222054012d199af211be2e0c4b66abbfb0403cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b07e0e6218af07c380fe2a9f2b897450fb40d373332d85fe6db3ccf411919ef4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build # GHC 9.10 PR: https:github.comhaskellstylish-haskellpull480

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath"test.hs").write <<~HASKELL
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
    assert_equal expected, shell_output("#{bin}stylish-haskell test.hs")
  end
end