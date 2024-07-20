class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https:futhark-lang.org"
  url "https:github.comdiku-dkfutharkarchiverefstagsv0.25.18.tar.gz"
  sha256 "cc39d841ea18fdafa748c03f552c5e240783f6a5e38485ef8d25ffec9afa7013"
  license "ISC"
  head "https:github.comdiku-dkfuthark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cbf0217c377ececc407eab62ce2ee66581729c74e23c11a9101286b72df2044"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8466a6a9c87d13e64dadb8b68cf3dd4100dc9a1d98985bbdc41eb1328ede8513"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da1b70f6115452f38b5d63796fd80c863593236e520668467b4114574a527f48"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b859f37a635a12949331309f34c9fc44f368ed407ff1353227885a129ca4b93"
    sha256 cellar: :any_skip_relocation, ventura:        "d594a10184682edce44f8a76b406a03b0e26f5cd5f5b5b9dca3142b6ebb64823"
    sha256 cellar: :any_skip_relocation, monterey:       "1b3d6b3342ab77e07f79ae04a9fad1b03a1c6c7156b42d1d056468d574a00da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ddbf214911e8dde8dcfdfdc7c0220d3793d2676ed3719edd815d43b5590105"
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
    system "#{bin}futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output(".test", "10", 0).chomp
  end
end