class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.67.tar.gz"
  sha256 "a5a167a99849e69c3f2eb9cb87fe4a793707ffdb37f8ad40f6dde74c3241e489"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "210a066ae3aa436f7c592468ac46ea39b178e5f7e0ac11194553a1c7f56f5592"
    sha256 cellar: :any,                 arm64_sequoia: "b35e4b7ee2b593a64ad5ddfb4d34f02ebc4ce242b74042c72e162ff6b6e794d2"
    sha256 cellar: :any,                 arm64_sonoma:  "abe18276d98c8eb85630b186f65c3883962511cb4ced6f4ce6c6d7cc723bf59f"
    sha256 cellar: :any,                 sonoma:        "e8627e78746d2e3b209a1a083385accdeb3c54e654a89ffee23e71d661c74ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aab8c38eb16a1e9ef626bf836338e4a5ba99add0313bec1bec710e5cd679b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a87a702e31e6a7f86b3d421f7300b493a043d09be31dfb34e6f61b9a62eab5e9"
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