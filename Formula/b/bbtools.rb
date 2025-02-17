class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.17.tar.gz"
  sha256 "3aa84afc9d01327376e43561f23036b522ef0d346b24c297e83ad4e9f999266c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ea4a107d6491bb34f1c8159382b0f6cf528b66f49a36b0a9c7f9dfc77a3d564"
    sha256 cellar: :any,                 arm64_sonoma:  "c5d40cbca5e6a52b1e452eac41d2c17db2159da87fa757054e122621328533c2"
    sha256 cellar: :any,                 arm64_ventura: "7e11152575f80465213c987b5f9430ac0778fca60d1c19a8e99acd344add75b5"
    sha256 cellar: :any,                 sonoma:        "2e3751c24dbfd35191dcd5772e53bd6ceddd4db6c7f6e502ba8eba265661fc1f"
    sha256 cellar: :any,                 ventura:       "2b71e717e2bd8526a8f09eeadaec6b84762c4a73099b1f159e985f43769cb894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ceedeb7a61fc531057872e899bed4f75d95186b51117cb95bbc478dd497910f"
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