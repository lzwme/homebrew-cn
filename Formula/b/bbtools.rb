class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.09.tar.gz"
  sha256 "df7871a18eff981d405472ff4bba3db8f99cac106acf3bb84d7435f260b33e54"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09f476419f584356de1c1f7f22246bdea2bb444e382d296f4ce8f0ed095c2647"
    sha256 cellar: :any,                 arm64_sonoma:  "55320408a56d48aef05b87cfedd28690c5e2b468d3ec401624cca144e10a5547"
    sha256 cellar: :any,                 arm64_ventura: "61435f559b45c96a2d522d007eefbf01d6ba13899ec6b5afd406c37746f7b3a6"
    sha256 cellar: :any,                 sonoma:        "72006f110af2f455633d6e1cfa01ba48a162b3e275b1331a839a37bf4427ab61"
    sha256 cellar: :any,                 ventura:       "53830bfd51f1db3f36f74b13ed768964010a070a9fc79dec2866c74f4b88ac25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e46c14f3ece87938b291daa39596eb5ccae3780e2dfe79e55fb713f935f8a54"
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