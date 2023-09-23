class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  stable do
    url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.7/hopenpgp-tools-0.23.7.tar.gz"
    sha256 "b04137b315106f3f276509876acf396024fbb7152794e1e2a0ddd3afd740f857"

    # Fixes https://salsa.debian.org/clint/hopenpgp-tools/-/issues/5
    patch do
      url "https://salsa.debian.org/clint/hopenpgp-tools/-/commit/fc4214399f06d4ddeb2ecf93ddd3d9bc9ed140bc.patch"
      sha256 "56f1666227d421b42f375c53b5e747090418a2f669b1e7df285c11bdb23d6390"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "359571c43c58a508b85ee454ed7739cb820ab76171b672121395a2ff1c97891a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22a950b1becb04770da6b835d0efbbb0ab473bf74d9c44393a1cc2b02dd37f55"
    sha256 cellar: :any_skip_relocation, ventura:        "5f8784ecf8c90427a17ea3d970a30311eee3f933b5831a2ecbb41b083b776c20"
    sha256 cellar: :any_skip_relocation, monterey:       "3de460b6a7913596fedba72191000532956232ab3b91a2bec1cb2e90c2331440"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1560215c06cec48de589a1eb1d2822822f5e45bd610918bc9d6b284b45cec74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31710cce55c0ed6f28a1fa468ab107f6a4c580e8478611a27a067509d0def253"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.10" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  uses_from_macos "zlib"

  resource "homebrew-key.gpg" do
    url "https://ghproxy.com/https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end