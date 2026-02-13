class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.72.tar.gz"
  sha256 "2cb39e1f8183d2788fa29ab6a2f1137e039b5b0df24dc0cb0dfb32b9c629cedd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9e4813cf32da29c6b5a26d82e07e0b3880efa5de9140bf6fbf06ffdd1233e74"
    sha256 cellar: :any,                 arm64_sequoia: "ff5f87fcc5956af5ae7a705799d0e4f6d188c091540a83308117be7cca2744fa"
    sha256 cellar: :any,                 arm64_sonoma:  "b668b2234061aca032c8e7e05b7c727cbfa05f758099d8806ba8bf92a3522877"
    sha256 cellar: :any,                 sonoma:        "15cfe23aa20067328a39257a5802fb890fd78b49a3b68f943fdc1544e904f339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd11de237a2b2e949d7f47a47dc89a3f1e6aff0d131dbe40e0b396fda64eccd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcfe202cd05659dfe651a9b70b9c245b41fe1e47dda18eda67f191397d7ccd3e"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[current jni resources]
    libexec.install Dir["*.sh"]
    bin.install Dir[libexec/"*.sh"]
    bin.env_script_all_files(libexec, Language::Java.overridable_java_home_env)
    doc.install Dir["docs/*"]
  end

  test do
    res = libexec/"resources"
    args = %W[in=#{res}/sample1.fq.gz
              in2=#{res}/sample2.fq.gz
              out=R1.fastq.gz
              out2=R2.fastq.gz
              ref=#{res}/phix174_ill.ref.fa.gz
              k=31
              hdist=1]

    system bin/"bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end