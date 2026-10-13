class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_40.04.tar.gz"
  sha256 "95fdf26330f3dcb8e2b28cb7cb20ab110c9d05aaea66cd4789af94e60ef3e76a"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "212aa327d787c3f40584252e89c278c56a606f54a8c2da7a33787f94b8e48578"
    sha256 cellar: :any, arm64_tahoe:       "b5295b6541539c152331a55f77129afc190e09c72830667e3c6d1f06240174f3"
    sha256 cellar: :any, arm64_sequoia:     "fca585dbdd435d8a66b6e7bb55a4e9e525f2bcdb39ea33b9a6aa5c1893609844"
    sha256 cellar: :any, arm64_linux:       "3cc9fcafa504962a1d5fcdf895071b7ccb27cb5d4ed7588b0684d8ca57ee3a3a"
    sha256 cellar: :any, x86_64_linux:      "7958eebed95046b078e6bbaacdb96711061d76b7f61a456d02d6ee7afecabdfb"
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