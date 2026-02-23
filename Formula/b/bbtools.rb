class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.76.tar.gz"
  sha256 "f1f8c38f09b6014c4d9e05e7585197806f6153d93624fe8045e9c26502745d41"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b38a8d78f8eb9883229b3192394c6a85fe2275563de3d799de4132ff57ba354"
    sha256 cellar: :any,                 arm64_sequoia: "60f80990bcc5939e588f640b9c90a8637fcda4740e48c7a36ab3f99fdf8fca7e"
    sha256 cellar: :any,                 arm64_sonoma:  "1608ce56d1ab5d534247e0f83ac8f21000cbfd4f43f4164f2c2a7685dcf60044"
    sha256 cellar: :any,                 sonoma:        "4b8c2e5b182667829ddcf99f9904713d7ffc4fd4e68b12a644e6254b968e8730"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4316d04b7928144b207f53f0288b2fd5db42bf02efd70f1b4b53e2ba8648aa26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "878a9172e70e51e7c5743b272f686f9b4b5d120d7a6dbacccd239fa06727beca"
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