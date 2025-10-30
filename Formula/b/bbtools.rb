class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.40.tar.gz"
  sha256 "8a3e5534a9624aa6ff1637450504780627108b8004a3c36721b2d05105ec7ca7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08151c4a61ebab83cced034b1452cbe8afa03ad2d7942b194b1e67470ca584b1"
    sha256 cellar: :any,                 arm64_sequoia: "78a09f76b17d7de22fe46bcb8cb9b82774de3f17f524fd3e15fd278fba43f065"
    sha256 cellar: :any,                 arm64_sonoma:  "77d3e1c33c3693c2feda14641646ada152019b6c84a101113188527a4527eeed"
    sha256 cellar: :any,                 sonoma:        "565d4e5cdce8aae8f4ebad32e03d81a7e32b2051d37fff802fe8510b0de9097b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec3872ffc78eb14bed08c2f1c8a5007009c118ef952a1ef460e87ffbc86dea7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec7dab5f5028b12754975cbffced491ef02f03e74a7036ab2b37c1d79a05762"
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