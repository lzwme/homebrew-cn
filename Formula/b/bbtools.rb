class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.91.tar.gz"
  sha256 "ab5dfc0bbaa5be338596aec3558c7a7c891e8d8b186e9bd671552466215b9b15"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5a3a27178dc2ae0817d9adc6ca214f032b19a3cc7271f5162e0b908eefccc3fd"
    sha256 cellar: :any, arm64_sequoia: "1894b2de5184164565975da69e3f513d30165a19905f40d478dd1639bec66234"
    sha256 cellar: :any, arm64_sonoma:  "28ac8a52d8b520d1ce85baa5cfaf2d8e5aaa1c606b4ff2d0026b1be96521b1f3"
    sha256 cellar: :any, sonoma:        "c140a47d520c840bd365f8d0fd9c23cb6aed6c65587c0c8778c66261bae5f5c3"
    sha256 cellar: :any, arm64_linux:   "08ecfa81cde8b54afcc61eb93daa280df3d0d2ea2d66cc7393631ee0adfbe0a2"
    sha256 cellar: :any, x86_64_linux:  "8dc43f354d62a331121c3bd303ae6027bdee5b6a1843d01fec1d1935752a4924"
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