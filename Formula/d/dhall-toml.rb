class DhallToml < Formula
  desc "Convert between Dhall and Toml"
  homepage "https:github.comdhall-langdhall-haskelltreemaindhall-toml"
  license "BSD-3-Clause"
  head "https:github.comdhall-langdhall-haskell.git", branch: "main"

  stable do
    url "https:hackage.haskell.orgpackagedhall-toml-1.0.3dhall-toml-1.0.3.tar.gz"
    sha256 "00a9ece5313c8b5ec32516e0b1e326b63062f9b7abb025a084bda5b69cae2935"

    # Use newer metadata revision to relax upper bounds on dependencies for GHC 9.10
    resource "2.cabal" do
      url "https:hackage.haskell.orgpackagedhall-toml-1.0.3revision2.cabal"
      sha256 "22bbee460a1b85cfb7300fc6d8b78c94d01c3a5f8b9f74836bac3f17302580ee"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "780e0f69804e6ec42753ddab457ba65206b731e68ee6e1b655f3dba777507978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77850e914f5774c848519d088375e566ac96946ded3ca7428da4fac4394464ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d7f38cc68cd120e3869d3a535cd7c1c4b81d094f1754f395cb7864b66fdac94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8a362df2578a98f41e80638d7adefa2863c96ba616ba47d4d97c4e8b71c9d54"
    sha256 cellar: :any_skip_relocation, sonoma:         "269389acf7ed1db191734e00d35889ce824d8ca709c7753f4282c3b4019f5e4b"
    sha256 cellar: :any_skip_relocation, ventura:        "4053831141433159830a642a31991506255863cd34f88cf59ee2ffa2b49954b1"
    sha256 cellar: :any_skip_relocation, monterey:       "251b76a91597eb42b33b19c96650e0959fcf5ea5b444071d14dcaf8496fe30d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d2f70692a5706db31dd4d82561f774cd476053fe678b6656309cd7ad074099"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    if build.stable?
      # Backport support for GHC 9.10
      odie "Remove resource and workaround!" if version > "1.0.3"
      resource("2.cabal").stage { buildpath.install "2.cabal" => "dhall-toml.cabal" }
    end

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "value = 1\n\n", pipe_output("#{bin}dhall-to-toml", "{ value = 1 }", 0)
    assert_match "\n", pipe_output("#{bin}dhall-to-toml", "{ value = None Natural }", 0)
  end
end