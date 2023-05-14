class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://ghproxy.com/https://github.com/OpenGene/fastp/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "a37ee4b5dcf836a5a19baec645657b71d9dcd69ee843998f41f921e9b67350e3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 ventura:      "ff4a4ec29f70549bc613998417d814c3844844dbade41a6802883283c2ab3a39"
    sha256 cellar: :any,                 monterey:     "e19dc8d8adfaf5ee4c4246623d7e38e6b0965e3c85b84d2ef452a3387c80608c"
    sha256 cellar: :any,                 big_sur:      "5aff2d769fa0be009939954395ad6781ff8d780fa529b0d6743153cec0bc8120"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f1c478eab42efddc27c741231dd4e2881224feb7df32fb790f9d36074f388561"
  end

  depends_on arch: :x86_64 # isa-l is not supported on ARM
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
    assert_predicate testpath/"out.fq", :exist?
  end
end