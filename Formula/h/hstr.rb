class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://ghproxy.com/https://github.com/dvorka/hstr/archive/3.1.tar.gz"
  sha256 "e5293d4fe2502662f19c793bef416e05ac020490218e71c75a5e92919c466071"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fc49b795a9a4182c314a299e959d3307a90e0dcd349f7a177f4990177fdbbd2d"
    sha256 cellar: :any,                 arm64_monterey: "db9cc4ec008f0de26ed8804a27497ab85e0ef5130cbaff99d36b7a9e290484ed"
    sha256 cellar: :any,                 arm64_big_sur:  "27b892cd3e184775eb18ad1538f102470d9ea46f2b12aaeae0c9369eb7d10ae6"
    sha256 cellar: :any,                 ventura:        "dab8c56dc9d4a3c14b97a16e4b7640e911fc263cdf8c0d051ef7b2f5914c5d68"
    sha256 cellar: :any,                 monterey:       "4d612879fc6066185b3b1cf9f334f55dfafbab73295bc041d3edc8fd1a2d0be7"
    sha256 cellar: :any,                 big_sur:        "196bd9dcd789830ca5ea6f3ee94ba43bf3ec0574cbc21196c0461a20b1b34757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f3e5c6ea14b17a5e83263bc1df77201cf44eee579f2663656c9912893de7df0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")
    assert_match "test", shell_output("#{bin}/hh -n").chomp
  end
end