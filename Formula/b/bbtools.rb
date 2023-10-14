class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.02.tar.gz"
  sha256 "bea2a81803e4878b6f6dd30bdc6887ed773ede638dfb58e7ab1cf94a7e4e771f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bab88d15ac7a2d59776fbeefabafdbc48b1aef9d3aa89adcb5b9f928a3b24d77"
    sha256 cellar: :any,                 arm64_ventura:  "3ff43ef24ad23c8588f6905a7b7fa6d9c2bbf49cd609b1ba28b7fd02bf094cc6"
    sha256 cellar: :any,                 arm64_monterey: "bb09fb96de568ca9c3ffbd55f5862a99de7c408a5aa6dce800f3075367230bb7"
    sha256 cellar: :any,                 sonoma:         "a1bff7676e52d8437e4bedd8f1d6f4208adbfe96a3d3892da03c0416cce9a76c"
    sha256 cellar: :any,                 ventura:        "898804baf3ea639c3ccd225b875532968aeca120053419f6d9985dc275a6517c"
    sha256 cellar: :any,                 monterey:       "b7115c36b3fdc0f8609bd5b478ba396af2f01ca1601b4a64384d6bab57f3d18b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74dbf1f0cf3af4b2422725ae921a1fd58ed81691094569bc24bf73a63b93113e"
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
    system "#{bin}/bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end