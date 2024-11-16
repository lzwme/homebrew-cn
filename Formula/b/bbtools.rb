class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.12.tar.gz"
  sha256 "e4aecce581f471f82a4223e3b817250c9b0999afa0d0b62dff0b9527182d2906"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aed7c8fd9154ea11ad9d9ebbeaacbbdfaae2fb90cfbd294c8d63b91319302bf0"
    sha256 cellar: :any,                 arm64_sonoma:  "951813efb9a8769c6f6a9c98b0e782d09eab2a418cae93a1954a6273b19a1710"
    sha256 cellar: :any,                 arm64_ventura: "46eb10782b446164b0b429b3b10b68a101590dc601bdf2567f3bd8ea9835fc5a"
    sha256 cellar: :any,                 sonoma:        "6ee14aef163af45c86cdf65a2073c1d75f6a684fe34d54327af18c0e810f2d37"
    sha256 cellar: :any,                 ventura:       "7a1d91a143245a355bd5f967bb800526ca3c1b87fc127c1ae2110d4a92ecff9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341a45acf99084485e9a58cc4ff3662deb808978140b0c17d5e081b44401ea99"
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