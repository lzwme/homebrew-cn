class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.14.tar.gz"
  sha256 "87f7746dee28629afb368530457e7d2dfaabb4f8c5967dba4269d9a724f78e30"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd11803a7609dc86b46a6a021979608fd05f817457643b0dd152b0839a93137a"
    sha256 cellar: :any,                 arm64_sonoma:  "607522e86ca14f3badd0f1fe2c3a74fa1412d1f91f170f561b331b5dc0918b7e"
    sha256 cellar: :any,                 arm64_ventura: "7d0faf63edbb65260f8cb5d64afcbadd1a0032b16b7854df3378a1d7bea684c4"
    sha256 cellar: :any,                 sonoma:        "b8511d38306e3c18d046cac7742dec4fd79e5b40541868fca9bba69c9e7a552d"
    sha256 cellar: :any,                 ventura:       "ade0ff955bcb67664702dca63ee307db2a660eebedce29bd27425013ba049308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "254b9dddc7499429930f3ae72620023f988d93622b0fb5ce5fabd6ea5b0a80dc"
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