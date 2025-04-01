class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.20.tar.gz"
  sha256 "020cbc21097bbb238b2c5a21b5ce5e8b8300695d9245d0612094fa2cdfd5dd28"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb5e7ffe525e8803c14b835ee3900e1da8a28990371245e310e3a8fcc53b222d"
    sha256 cellar: :any,                 arm64_sonoma:  "f763f6aea396ca8db08a70d672ebaf38fb855a2e9e5530b0919c9a061b096f2a"
    sha256 cellar: :any,                 arm64_ventura: "a1f2da5dc8649681e14f75e87d1abc9d89724fc407f701ae48dd9fb8b2a32e3f"
    sha256 cellar: :any,                 sonoma:        "3d0360a8bb8e1bf3690f829f2e2583b8563f646dac1762f10505edeedd0626f7"
    sha256 cellar: :any,                 ventura:       "ef6fdf4d63e16a953a975d6818675ece681143a52a7e78e67b6c237a7d2d7e9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ae4693ceb27bfaafc9201397cdebbe010d1be9f50cf94334b8d9a46daf8d9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44775c9f5e7429c5faa4af54ea4ef55383472fecf960f1d5fb095bf679008bcb"
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