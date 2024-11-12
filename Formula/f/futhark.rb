class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https:futhark-lang.org"
  url "https:github.comdiku-dkfutharkarchiverefstagsv0.25.24.tar.gz"
  sha256 "6703a8008557c125e323f84a15cba6226193be5ae9944404158d5dd81872e0d9"
  license "ISC"
  head "https:github.comdiku-dkfuthark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "164bc6ad676007b86c0ad315875d55fbdad35b9f4f29c570e841528f64dd613d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0929b3904eecc0c8ac71fcad00cbed4eb93fd1eb797eaca02a539b764ce08a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2824c38f6b7a1bcbb1d5aace295c3a29d878a4a9fddfa3960cb094d6ae089a55"
    sha256 cellar: :any_skip_relocation, sonoma:        "8103c203b9067c4e6046f1819cd6a715b75d14ba02fb5007472796ccbd3b6ee4"
    sha256 cellar: :any_skip_relocation, ventura:       "d747284615e8dd732b4020e121a5be930ce5a75556dfe0d6f1f078aa0e8cb1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77472427b6b521928f0bb2bc6d71209cfffdb4583f5c7d870c8c2e6717c8ff39"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs_buildman*.1"]
  end

  test do
    (testpath"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system bin"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output(".test", "10", 0).chomp
  end
end