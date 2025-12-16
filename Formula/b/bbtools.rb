class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.59.tar.gz"
  sha256 "a657b6f04f35125b31e431317927d3adc0a3d3655a36014aceb0e3fceb0d4cb0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c6258f75efe97283f3ccf196647f0ddb0e89a3c016b07cc9c71cb6bc39224e6"
    sha256 cellar: :any,                 arm64_sequoia: "503337221c614686bf90aba8bbd90b949d4c3518d87e7efaee6ed897d43c0920"
    sha256 cellar: :any,                 arm64_sonoma:  "802c06c16b3bb7c66f0bf8217b85b5abeabae6cca047761c333967d4e627a844"
    sha256 cellar: :any,                 sonoma:        "c9ddb78d0e51400a810f4ed00acfb042c5383733385f15fe09dc111ea70c9161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2219452940443600723e68f7316dbd488046dfffb94f45fa8e08476b48247c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79a7564655094df0b69eddb186bb9bae924c836d3b1315a4ea08af6ab7c76e5e"
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