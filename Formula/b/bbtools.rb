class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.87.tar.gz"
  sha256 "d3f843124a7f6441477964d68c5b2c3abc6171cc364574d148090105b23a5dbf"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4dc5e8bdd7dfd11c8bc3464716fdb5e36a00d1c6b8578a0a88adb3701776fd6a"
    sha256 cellar: :any,                 arm64_sequoia: "12b470001e510398acf65581c05ffdf7985a21e94f7093130c6d458a3f8f9d37"
    sha256 cellar: :any,                 arm64_sonoma:  "c321c93c5e3b79b137e6b70aa64b81485e1105e163d57174297ee2fc6e3cfd4c"
    sha256 cellar: :any,                 sonoma:        "773e0520af03eedb954ec7a14e2eeed6e1b1e3a545558ca2edfcc8cbfcaad4bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d31fc48f7ad584d087a3cadff54daf8d1f405597310106dd02ce276da5163641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "085004e33391990ae440d1e0e096f30dd806641e0e657cbe99f4528dc1999fe0"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[bbtools.jar jni resources]
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