class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.37.tar.gz"
  sha256 "8dbe05e71c1916aa18fcda23da4b724ab74f073f47066c051d5da924ee2dc0b2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd2904e995b30f264d95411e1e57070c8f561785b861cfce049679934854146f"
    sha256 cellar: :any,                 arm64_sequoia: "706ded180aa58d09b03195fb68e5ca45a5b24caa81b170c9c5436324d38f2222"
    sha256 cellar: :any,                 arm64_sonoma:  "1d19bab468e8f94d676e8dcf8013b328d7bb7e5f36df5f84976d1eb49a268a45"
    sha256 cellar: :any,                 sonoma:        "550c7984040b87fc0bb85f311866278c9ce3314bf3309160ce3f3766452c184a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88d985a32df13bfad83cea92779af5c559c7639bc4a32302db21e8de75c715bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "814beca574daf51442de889393e5d4528c85f9989b6988c92955abc91a7e4fdd"
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