class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.05.tar.gz"
  sha256 "b457d784a728d7ab23c0a6ab8a549755b53df41bb0cf31423154db2f6deaae0d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28198d83ad58d897a4ec40449250a1a2713c1945592a434a815a8ef901e57698"
    sha256 cellar: :any,                 arm64_ventura:  "e32ebb5c3401c9b2525c653d04260d47955a3aee7b276a21ba2f769f6c258908"
    sha256 cellar: :any,                 arm64_monterey: "1eb7fe26737e7cd6f41784d3d21d7355f26a7fb9f632dcddb778a3b8b3d38a94"
    sha256 cellar: :any,                 sonoma:         "b7e2e717ddc506bcc2b49414542029b39fd314a716b986533761c0af0f1b8a56"
    sha256 cellar: :any,                 ventura:        "40cfd7b5089c525a90529f48f040d36b10fa27bebdd0ccd9daf3f1e6532b39b5"
    sha256 cellar: :any,                 monterey:       "abf07c398b427c406d82c58cdfd2fbbcac4e48daf9ca1aa81f6f372569c0c27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5398c4b5506c6b294ea67913bda2013f76a0d82a21542713b5221d267caa51a2"
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