class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_40.03.tar.gz"
  sha256 "b58cc0d5b6b33af9bd36f1f95e130fb6df75021959b8c41ed24439179515fbeb"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "465640ab44a94c61c1dd10b570685da22c9d1337a7166e88e3224b6ba61709d4"
    sha256 cellar: :any, arm64_tahoe:       "7e039bb350bf8604e6c346180f534ba57293785c81cdb9517a4be8738cc6725d"
    sha256 cellar: :any, arm64_sequoia:     "7dfeeefb2049bd02f989b78328866828da2dae09067cd3b39ce17e9e5ea9a273"
    sha256 cellar: :any, arm64_linux:       "e8cd4e455dd7db20b34f8d025f04972ac22fbd50c088e0b03ea63e2d0413e605"
    sha256 cellar: :any, x86_64_linux:      "44777127f21f33f9d0d45f93d41ff4661df1e75694e53186d88431554c2286b0"
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