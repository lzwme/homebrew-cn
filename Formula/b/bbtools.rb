class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.85.tar.gz"
  sha256 "8cedb08064eba414eb6e0573927294ca35500f53eb178bb9bc7357a894482e01"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ca54b7b60111a5fbc5753b2dfb78d34ab7a0accf41e85f9080dcdd762f41e57"
    sha256 cellar: :any,                 arm64_sequoia: "5dcb1d9a2433136d7d49b28d127ba116fc5de1a2e7b4bfba8282e7b5611998ab"
    sha256 cellar: :any,                 arm64_sonoma:  "d12dac30cedfb9ee47759ca0424eb7035d8e3bd5becc62d40879ccdcdfd217a8"
    sha256 cellar: :any,                 sonoma:        "c0c838f257b589f8e0cfd19500cc5a4aad480775cbfbbfa5a4571d3daaca13f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aab9b7df57e9f15ad5d6466c0215d8ff0aace9e6ed0c19ab1729635def429ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee098fe790cfb5ebbfa4ebb7234956a258777fec24f9a52b7e4b013af5045af5"
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