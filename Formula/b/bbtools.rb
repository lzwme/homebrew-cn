class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.39.tar.gz"
  sha256 "6a1daecc822ff0fbd5fd208fca2de41eee35477fe020bea41be624cc2696ee5c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b450ad4e265c21fd85b05bbf3d6f950d7b33cbf244ef60ec549824f79dbc131"
    sha256 cellar: :any,                 arm64_sequoia: "3f7bf98a639f676b981526e678da6df8728d841a96fe41e8465a09daa81cf58e"
    sha256 cellar: :any,                 arm64_sonoma:  "89de17b9b3bbb35c660a424eeb1326d788d85d0f3a5bf432195bafddc05a9770"
    sha256 cellar: :any,                 sonoma:        "5b7c3ffd272b89545e589142795022da9c9789e36c915f9178eb0f9e9102140a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e069b862a95aba600582aaba17890a13f1588c0e3637c1febad50d6e4193df4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e19f964a7cdc73a1f96a1324b6fdcfcb23348fe42bb88f9f0095d3d2936d088"
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