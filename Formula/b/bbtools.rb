class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.68.tar.gz"
  sha256 "9ccc912e29ed2bae73da7abdad03a59e7c245000b69902e944c6ec99404c1712"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e60c179972018069f813e9ea2e1b1b688136a87858d347ba931b74fe026eb7f"
    sha256 cellar: :any,                 arm64_sequoia: "939a65930e99bd813d13adf82a502d0c424dc18f7aebe48428b3eb34e9b8c88c"
    sha256 cellar: :any,                 arm64_sonoma:  "2f16059faa842328f48a132a7bae995f0d1fb151a3e4a5247eb52ef659077d27"
    sha256 cellar: :any,                 sonoma:        "e9913ba972b5cbcc15d37a0f5f7e868ad1745fa30b0f1697acfb523fd78b5896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b5cce18b2e894a7ea71badd6d4f88bdc9dc8bc62ee594789cf158cc8c4be816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "008d17f194d5b22f77b9c826ae594bec80e7990896f47ebc2b66e46e722fa3e3"
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