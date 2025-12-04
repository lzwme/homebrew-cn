class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.55.tar.gz"
  sha256 "ed17aa113911b9b7852e9e71ac07573ca5388c2925ba60d198bf940b2c241017"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac706c64672636127fc3d7622a0f64280f53f548085ea1c845a4e108b46a026a"
    sha256 cellar: :any,                 arm64_sequoia: "37aedaca36ad9cb1fbc89989c9e9b0c586fcabbfa6f6db979e003693ef6b5b62"
    sha256 cellar: :any,                 arm64_sonoma:  "b13330c5e57276da4dc43a649c3995615931d2b04de8f8dffc607123a9425594"
    sha256 cellar: :any,                 sonoma:        "652419227a05437963fc8d8952ee13a2e326740f2b8f9fbee76d62c703f10be0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbbe755d6aaf31e0cb999fe9c058f2702904950f9e15c9342dcc0f7962f941d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba29290ebf86869c2301b49f005fdd5cc294cd07bc9875cafefc9c190e8fb8c0"
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