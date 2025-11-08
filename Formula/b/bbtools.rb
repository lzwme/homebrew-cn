class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.45.tar.gz"
  sha256 "5736295ec9cd76ce13570847a1372cd46f8bce9ec5c432c520036e4a8ee3efa7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71cdcb5f8698226c3fc06f89f7ded1203d00729e829b5f7b5e410e2085c1637f"
    sha256 cellar: :any,                 arm64_sequoia: "ef81c540472ca16ce2421d1a2257800bdf188e65096daf0a4d3ab41a12130096"
    sha256 cellar: :any,                 arm64_sonoma:  "be319c495dd2f13e50ff90637443d63fb5c8cf6ca1c19e1c6f82dca055087f3b"
    sha256 cellar: :any,                 sonoma:        "debd293904ed73149c5fe60309e0d26c1d8822b3fe62d750366476fe3da58946"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "108c2f6fa0de55caa774a3a9a521a0433ac860acc8cc38fb75ab37862177d261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cec18b02c92668c2b7c86384d8d81455f326d41a93a9105a3e0267f5a753b58"
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