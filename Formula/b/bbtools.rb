class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_40.00.tar.gz"
  sha256 "e2f1e877ac1975f74558c843c05f551b3eb13f1dc6ad4484fabfeed5c8f1b369"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f1f1380064363f972b795a0fd6617d58bf0fdc254cec448277585931eac5f674"
    sha256 cellar: :any, arm64_sequoia: "897831242776dec1d929cf2a3bef91629a7aa0b8642ad5ac9f7dbb9209c9aeab"
    sha256 cellar: :any, arm64_sonoma:  "04ec1835376f3d67e3b0fc66fa6a7eb36d65d3c8f4314134e8cb898d0ddd103f"
    sha256 cellar: :any, sonoma:        "c8c42f0d13e433bc8dcf2daccf4389adbcb2b0e918b963837d749fed62b9c4f3"
    sha256 cellar: :any, arm64_linux:   "d5a822d6d92026f2145a76da72d03941326d647495d19f5d2b42b9084c609e63"
    sha256 cellar: :any, x86_64_linux:  "700c5ca9a14094a567c4f6723259bc82409cdd0f7d1c24f72ac51f24fa172286"
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