class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.16.tar.gz"
  sha256 "53a3b917321a704f7c974686675a299d209132442344f0b8431234f2aeee0cf8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "54683eb418711c6ab70723fd7e74df9b3892d703231d0418fcd9252d71f893e1"
    sha256 cellar: :any,                 arm64_sonoma:  "030167f4a85c2b1b3a1f54d944475abb6059e3b3c7e6c295e05112dcdf8e4732"
    sha256 cellar: :any,                 arm64_ventura: "81112cc11c611aa522868b307d3fa79299b8c4f58f9c728afb2584df15a773e0"
    sha256 cellar: :any,                 sonoma:        "e06c8cf427d6c0beab02b255fc218f569ee9f60790a55aee4df698778e1b5b8e"
    sha256 cellar: :any,                 ventura:       "203ba01146760c6489da1275af639c1692939ebe2257d3a2e9356424a560e721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd91c25a539f76c04479d95ec7df9835351207d32013fa2289754417fbcc3b33"
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