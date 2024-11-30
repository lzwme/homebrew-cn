class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.13.tar.gz"
  sha256 "6920a94549d3fca129e031cc14e5306ae571a223410e1f116b0292e530c433de"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cafacf5c489583f7fafa8de3bcdc715cfee2399c6ddbf5e04418ef3c93e032a1"
    sha256 cellar: :any,                 arm64_sonoma:  "5df905d4cbc60ba1e64d44debea9a428fa4058b612ab4014264c4a9cdc773553"
    sha256 cellar: :any,                 arm64_ventura: "fd38095228f810842a7fe51b1fec822abb22d3a24fa379a0266ea97ac225cbaa"
    sha256 cellar: :any,                 sonoma:        "dbc65e0d16882a13e2c62280ea98c2de3ad3bf7a0da093dd98ff639821da86a4"
    sha256 cellar: :any,                 ventura:       "6aeffe60fc090e5c0488603228dd553d3b214aa27421c19a4dbcaf199f85b4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d05b48ec364190fcc09342acdcc90669ba88bf38e82e1cbd7c53b9c727da1925"
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