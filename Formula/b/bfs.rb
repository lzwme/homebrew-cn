class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https:tavianator.comprojectsbfs.html"
  url "https:github.comtavianatorbfsarchiverefstags4.0.4.tar.gz"
  sha256 "209da9e9f43d8fe30fd689c189ea529e9d6b5358ce84a63a44721003aea3e1ca"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5552689137e104b1aee61a90d3aba3b9f7b1e1e9fcce057c6410b272965013a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0065a6e741b15d10ada4de3c7feb0b104680211fe156a39e3ba94b2ff2712e74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c61b922193327d4765bc2197afaceb8f4a1721fac902cb4382506691ac9851c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6819d8ceb9706fdce6c9b8bdb39179c9878d1955e17abe56587bab01bc3e18da"
    sha256 cellar: :any_skip_relocation, ventura:       "41a8d395a39271337b0d531cac5c7d99eeb3920c4c3bbfebe0c5fc7b881b072c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991460e41b715564748ecfb54d11bff9d4e1a9343c3eb8ba1afaafc82fe7be39"
  end

  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system ".configure", "--enable-release"
    system "make"
    system "make", "install", "DEST_PREFIX=#{prefix}", "DEST_MANDIR=#{man}"
    bash_completion.install share"bash-completioncompletionsbfs"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal ".test_file", shell_output("#{bin}bfs -name 'test*' -depth 1").chomp
  end
end