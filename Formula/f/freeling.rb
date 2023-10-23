class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://ghproxy.com/https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e2a3b653258df8b0dfb17a96c18dc243398d24a2e77663ad77ca1a80cfb38a49"
    sha256 cellar: :any,                 arm64_ventura:  "3cc71b269904e9904814b0d6e4439ca7bf5897fbf8f87f69e9d844aa03c15c49"
    sha256 cellar: :any,                 arm64_monterey: "71df3f25d9c05a12919ba1d9b6f6d0d43f2e22a894024d773cfb9c8a9e559b2d"
    sha256 cellar: :any,                 sonoma:         "a9f0ec13426454ca2e7bb03da72f5749248c04846cdf1ea08a1957af76a6d84b"
    sha256 cellar: :any,                 ventura:        "7e2524a5bf4b3eefb5e4bb4e48b4df5dc76eb03abc1f001f6d0d61ce19805d32"
    sha256 cellar: :any,                 monterey:       "54b5c15f867edfcf83192ede672ca653bca1cb42fa7bcc253d0636d0397f241b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f75250f361ab01ea9b316294e8d4933274f41299ac5e8be185a195f3418629"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "dynet", because: "freeling ships its own copy of dynet"
  conflicts_with "eigen", because: "freeling ships its own copy of eigen"
  conflicts_with "foma", because: "freeling ships its own copy of foma"
  conflicts_with "hunspell", because: "both install 'analyze' binary"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<~EOS
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end