class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.33.tar.gz"
  sha256 "b82d06579e118467b5f129f06c93991196d25cc7e43cd233aeb777f85507175e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "627fc9ffca035d04926fbb5359e7120ad448ddb1cc24ac47cf8de4ac7be7cddb"
    sha256 cellar: :any,                 arm64_sonoma:  "7c30faefc226b1654258adf44d90bcf9b38d3d34128e2fc67b0bdce358afa8bb"
    sha256 cellar: :any,                 arm64_ventura: "68fdba2c838fd1e8afd5243255adbeef092be2019370e8207695c369a5a338f8"
    sha256 cellar: :any,                 sonoma:        "e83cdfe7e18a3c719d35b59a0262771081183e2d1909cd2c933d28634a36b1af"
    sha256 cellar: :any,                 ventura:       "4b6e1fa2e2a95106fab07caf23d581720454bbde6540e9f6ac627f72189f189f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbb6821688e10a55e549cf52da4aa7ecff38be8be4a906ab733bf83df0a761f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f982e275d268f3bb1e1e471b762cbedeb80876c43ff77356d043c0304e5d2411"
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