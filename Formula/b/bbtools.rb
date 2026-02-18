class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.74.tar.gz"
  sha256 "9826f7dfe3b4fd3623843c4c5d0d9b14f9563047a2ef651110c38355a9975b68"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d38c6a15169963a06b403a9721bbe13afb9407f9111b3b5b49926d795f882c4"
    sha256 cellar: :any,                 arm64_sequoia: "313f45241fac1cec4bd14810586b2b2c5106cac1c1808e1cdbcb2c42416d2a2b"
    sha256 cellar: :any,                 arm64_sonoma:  "d9c93a0c8aaa3fe83603385c17f34dd98d25a6d57f6332fbe5ec5ace59b8a271"
    sha256 cellar: :any,                 sonoma:        "5ed331494b4d464f2b65ab378b1b2752022f4f6a3de9845ed84b9a5e75a8d648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ad74dfd0a223d6055cae46b7af6158f37f3bb69e0ef1c420f01f5349f353ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5081f26416dcb4440cf39a4ba808143840f528bdb1455026f88dceaff9bd5fbb"
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