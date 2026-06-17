class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://ghfast.top/https://github.com/OpenGene/fastp/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "105c948dc11e567ca6d7532f76ef53b456505256b5ba16012a0182810c28b591"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "884c01d61a7d98ee1861620df5d7f77e0b49d8cae1a7d84666ebba583f0e3f3c"
    sha256 cellar: :any, arm64_sequoia: "8f3ee4e000c5fb0441c21960b5d068c97895f55c204f03021ab2a56bb388a7e0"
    sha256 cellar: :any, arm64_sonoma:  "d9a952738af5ed1fbaf146c7997c3cb8945e52461370ad211187cb2d5e56132d"
    sha256 cellar: :any, sonoma:        "691463c93cc65afe3d48bbb86afc8cd10a5a7afffbda627e876ea0123515ae95"
    sha256 cellar: :any, arm64_linux:   "8d9282a4ad41bda3fb2b70180fd1247238dd541f3194c62d0da2422d5aafb495"
    sha256 cellar: :any, x86_64_linux:  "50c5920c90d95daf9d49670074c12cdd067d55bd48e5d2acd4d57db9cde88fac"
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