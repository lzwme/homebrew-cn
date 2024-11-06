class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.11.tar.gz"
  sha256 "bcb80b109757a638d6c767b7ba785fde5111437f7025e0a93dce587cdfaa2795"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a2a94c29d498cd11f81fe92e012d334e4490db0c6d84ef8dfd68093771c6d14"
    sha256 cellar: :any,                 arm64_sonoma:  "683b2e520e7ebb2fab356a88dd8e53e845d502ee5208bab2cc567bebf50d8dc4"
    sha256 cellar: :any,                 arm64_ventura: "17e07f745f6a2cbdbac851877f87357fb79fca50495b26a282c8f5ae116a94c4"
    sha256 cellar: :any,                 sonoma:        "18967de2b4f2b73a186c586c459d4b7d11ab3843c43c54665b43641f0b714c82"
    sha256 cellar: :any,                 ventura:       "9192da6f6333ec30ec26f6735535ea0335c2e41cdb3b8c98f0cac4ba49bf3ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc0b0b59d9470faf9ac8f2a537daeeb78a1b4e7adbd25868fea3880e765b549"
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