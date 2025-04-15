class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.22.tar.gz"
  sha256 "5072e94a8cc0f76a93a7cd594dccc1f67d112604e06feedda92f01f166583db7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "220e3f120864b76793a3a96f63373799d34b7ab2ee7e4f6014d2a0b353dcf2f1"
    sha256 cellar: :any,                 arm64_sonoma:  "b4e7e0261d5032e504db6b755aeebcdf79df4c84676f6dd2a888ddaf13dec0b3"
    sha256 cellar: :any,                 arm64_ventura: "c160cd4e89ff05ca2594e1df5f8897f3e031a085c7f955f06b3cdc6e3735b40b"
    sha256 cellar: :any,                 sonoma:        "eee4fbf08c2d60599489796a554bd17408e8449f116828cbd86b881f785c4ae8"
    sha256 cellar: :any,                 ventura:       "73446e6b4cf3ad5837472034760e4adde93f9e9d12de7ab506b77eaed5c3457a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654e364cd0ebb7e3cb55a3200a0743a732118b58609675307f11cb5e8bdb73d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7913b13625345aa4fdf355224a111263c73f47e947f3a2a209656ff887dcebf7"
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