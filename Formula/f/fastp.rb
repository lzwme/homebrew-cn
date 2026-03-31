class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://ghfast.top/https://github.com/OpenGene/fastp/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "c4ace9d14dd412954efdfb6160a6069175fc470cbcdbd4d379eab6b7eb835d30"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8ab56fce15d17d4f3c1683533074d0bee1986b9ff064b407c318c1555ea24d9"
    sha256 cellar: :any,                 arm64_sequoia: "a56898f08b7ee4d2e79df0100818cd65f1880e6309b01d06f75d0fb637f993b3"
    sha256 cellar: :any,                 arm64_sonoma:  "78c63fb2fab9c71a6d91d4af248096445285766df125dd61bedeebfa612b40a3"
    sha256 cellar: :any,                 sonoma:        "3fad557ef62ffcc4c6ea69131a95efd6efe518993abf70ed45db703cb09c6757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97987dcd4ede63426b9dcc9d442cdb6140f642d1d053752b0b8a6e380cbfa5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d4248e49e4f85e5c51ab1ff6d25ba6c20e7cf593a9f21153992100bd99895f"
  end

  depends_on "highway"
  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix/"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "testdata"
  end

  test do
    system bin/"fastp", "-i", pkgshare/"testdata/R1.fq", "-o", "out.fq"
    assert_path_exists testpath/"out.fq"
  end
end