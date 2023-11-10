class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.04.tar.gz"
  sha256 "a9bc7086f8d560ebbd99081cadf796adf6fa1994bf0c84c84c4c445244cab91c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9f2eb27d1a22bd12f99ac3c77e1cc509d8ace1a3612329cebe03d1599dd70c20"
    sha256 cellar: :any,                 arm64_ventura:  "ac6b1e39b4804278deb4657e17206eb1259c3ed5e4999c86f14fc41dacbcb6f5"
    sha256 cellar: :any,                 arm64_monterey: "62332afca46f1b13bdd96ed079f9a04030d4254dac866e7fcac9fb1b48095174"
    sha256 cellar: :any,                 sonoma:         "1d644892e6d631534b938f1e93e63bf9b62fae18025893e5a59039077714f52b"
    sha256 cellar: :any,                 ventura:        "eb6909803fd6e4c1007ec6286806852bfc6c8dc67664f9d4357b2044cf8fb2cd"
    sha256 cellar: :any,                 monterey:       "eeda37430f618d34b2196bce8944937e3e5687f84ca1ca94b8fdcba6bb0059f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d86f402616cf169a6fb0cd7c91a9ef4dbbc457df476107576e344882c3bf364b"
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