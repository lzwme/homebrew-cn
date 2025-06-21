class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.28.tar.gz"
  sha256 "b82f3adf10585ead446c03cc6c1595fa0a829b468bf948946503512d1ee807a2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d7179a4c8736bfc5185d647b94f431fd25f69e810ac5aa461eb2b3458d5d8138"
    sha256 cellar: :any,                 arm64_sonoma:  "98f5b3c299d3ec86010c6562fc79df69c7f3c05b51ba32a3b002768b206af0e7"
    sha256 cellar: :any,                 arm64_ventura: "ee4256ffbe8e459b5377e4ae65d99d5b202478f64dbd6aaf711f9dd06719878d"
    sha256 cellar: :any,                 sonoma:        "d1dfc3ed77566931778b27e0c11e0fec6b8c8ad6dda38acee20808d5288f96b5"
    sha256 cellar: :any,                 ventura:       "0a7e8c902bb5fb720f0882837a4882f1dd16ce81fcb7c5d7de507774e1b899df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "694cc413647f9943bef9b773056c082a0a7f2f8ecdedd269e57ca73aa9f20040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be17ffc1ec15e81967b51c624e719360acbaab077c0b3aee69c3678ba8bb22f7"
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