class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.30.tar.gz"
  sha256 "dc03da8e9c4759df915b3c90c3a2902067b94edc3a29edfef6521327cc49364e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f900572ef117789c613ebf4ac350a53bb617aea7385425c2d7f7ccd073fa6b1c"
    sha256 cellar: :any,                 arm64_sonoma:  "77f6489b9b9c637972c765225c1a033db04d5b5961b196fdbbd8032dde8770ad"
    sha256 cellar: :any,                 arm64_ventura: "a0d5b399318e044e95c1eec00566aa97faca1dafc1aa36b26d6238b1676d551b"
    sha256 cellar: :any,                 sonoma:        "8c07e7ab4a3c9718ebb879a76b274fe40a68a2b25940f79ef6893d8fbc54ffcc"
    sha256 cellar: :any,                 ventura:       "948cc3cc3dd5275cabf392c3864dda417d30945ec3a43bb2b9c94bf15c89642d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ebb3ea9a530d40d495f9b24c21ebe059bdc919a69018959bfb8c53653790811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807f1cfbacb9b4817b510450ffb91c68a790c17fa2ba71113d89ef2c37a8f9cd"
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