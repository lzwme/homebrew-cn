class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.27.tar.gz"
  sha256 "1215b4fa39480fb2eb668885b3cfd9cc42d5f773cd37c04e8115f6cb82789d97"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e98fde7c34887db44115c9772808abde0752466f39c20f28eec693cbda99ad3"
    sha256 cellar: :any,                 arm64_sonoma:  "7d4644773b112e3bb689647cf55ea01fd1f2372da6c2d6e77d9adb1289ec35ba"
    sha256 cellar: :any,                 arm64_ventura: "357bde548e0e72c51112d28b911961f6ad671cf7368c1f8280ca2b8c4ff59e47"
    sha256 cellar: :any,                 sonoma:        "cf5c54b526108895e8c056ecc13db0485f9693e65879590f33033e6a5403d88c"
    sha256 cellar: :any,                 ventura:       "5c02706c3fd026f1c581ccdfab1b1841a46d20c231e69fc84b657a5833d337d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebbfeab5707248d20a96083101526fc32ff5eb5125af5d7fd52aa0f44a1b1983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3e80047ca70fd43fab885f410ad3cf43293a86218b7c05daa84cc671536d5d"
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