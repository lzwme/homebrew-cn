class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.77.tar.gz"
  sha256 "d70359dc846b8a3ad2f4f9aeeb451e2837371410201f4db7ac2b357f6db5d804"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39605f3e80c6f7213e5b525e4c0dd50212b2f69db5fdec1cfee2ba3de6ca320e"
    sha256 cellar: :any,                 arm64_sequoia: "071201cb79cb73aefb72c541cf249ab4dbe45d9aaaec0820280e9b5142355b72"
    sha256 cellar: :any,                 arm64_sonoma:  "844041feae593d8a0b8fdd2c283f1d89536f3a02fe62115fa11b7225935c7901"
    sha256 cellar: :any,                 sonoma:        "86b35b870d013574cb858b3e3bce0e7e7b6a3febe8e04f48986ccce996311525"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36dac7c79ef2c974ec2e6f01bf01811dbb2ba83ad470193e8e6c889adc38a430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d9e9e5fbe357daaef33fe49602d44f9653c376134bb8b09167e65f2e3591be2"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[bbtools.jar jni resources]
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