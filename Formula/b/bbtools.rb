class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.48.tar.gz"
  sha256 "8fcc01f15248739f2031ecfe1f82b8154f1c0f269a16fa2444f500d8cc7b61b6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b5b955000023c81f01e27c24d96a88477397afbd35eb2b928d9000be5cd6552"
    sha256 cellar: :any,                 arm64_sequoia: "4d2be27f2be3df36b8e01c80c96810448420a6262ae1ae835856f050334e1792"
    sha256 cellar: :any,                 arm64_sonoma:  "c7f00600be732e9518c6c8c6d049851b13cf3e851dffbdffaaa53d47a4d51b4c"
    sha256 cellar: :any,                 sonoma:        "431e715eea67a0519cca0cedbcb706cf13b868cb7b301ba29f8de3adef515760"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d704a75836ff829d77e8acf6ecab7bfc2ba5db2ae65a2c5b44a3f859554cfa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cceb341bed91fe4bb8d894a800e07cd8a2b6b39bd7be2210d9dd1d9e6476bd44"
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