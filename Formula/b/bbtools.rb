class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.79.tar.gz"
  sha256 "e4906d808cfb4e3effbf3e628bf8c653881a8eb0b01d83366414716dd3ad0bbd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de869aaac82c95c89a350191b16b170bfb39212a2ae0648ce517207e3fb3d998"
    sha256 cellar: :any,                 arm64_sequoia: "9658134e255143ad151b29495a6a1ca47e32326b262200facab58872a6620138"
    sha256 cellar: :any,                 arm64_sonoma:  "e786db8022e8f6598e951085888d00f7b16c9ec04c20bdda7a3ae274acb951a8"
    sha256 cellar: :any,                 sonoma:        "fc2a00bf10ce8c98babf3ad81a2b6386ccec191e87db4361d88c653cdb13fcd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31604b6ff0f0e4b8aef4ee68ef06606f7cd6e7e1b67258ffebe64c4710d61578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d0cd94c76d6fdb381aa90bbbbb052f8cd91495536d3e6c902575ccebac47783"
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