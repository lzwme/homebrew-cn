class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.24.tar.gz"
  sha256 "91d836dcd42227053f5bfb1f7137e7e51bb9f9b7e7e63e093c7a21c5306de821"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dcaf89dabceb9cc205c2821aaac24ca285463988cb649a14689d24e4bebb7ac0"
    sha256 cellar: :any,                 arm64_sonoma:  "c2c5f9605ae169ee5db98beebc3f1778f6080153defa11d7c0d9565a2134cfc6"
    sha256 cellar: :any,                 arm64_ventura: "4fa8dbcc5770a256225ab0e4aa4ffe75d0a0987a637cedb6cf94ce4165ccf6df"
    sha256 cellar: :any,                 sonoma:        "39c6b4e71a2036237c5d615379dea76b27bd2b1fbac1a8d8f541759e54ec52f2"
    sha256 cellar: :any,                 ventura:       "f1ced49efe430f735f749a3791ecb1b67c67f045ecd8894e94681fd2a18a19cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a4a7d2031d3fad8c14cfe5b5f1deb5926c0aba0b6b306e956084425147af268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f0bea1969ba2c8d9816a76f8f8e70f166868f824af2ad19b4c93715646ae49c"
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