class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.31.tar.gz"
  sha256 "abc5b06dc8543ad894b441d87a2968628781fb5076d155e8ee06c565c85d5c19"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7fbc4984d0a7bd920f2042b5904ed3c97474b4cf5189fae500c0ef6f7381e818"
    sha256 cellar: :any,                 arm64_sonoma:  "d37d6d1b8bdff78c130e0fadd2adb32d059abb960fbbe67dc810b4dcc5f6d38b"
    sha256 cellar: :any,                 arm64_ventura: "c35c5ec19e656d9a59b891a221d8e750b68aca1ab555a26b5738de2f512a72b9"
    sha256 cellar: :any,                 sonoma:        "6f28ccdc08ebe66292ff7a62ca7d66ee5153e8c16e50a28588ab7c7f058750f3"
    sha256 cellar: :any,                 ventura:       "a4eb4ac842644bd850516bed821c1cb8f7bbb46a267d0547c7b31e6a97118541"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f957d26554ff6cad715e6a8e26ca6e8575cbbceb0f6d70036f34e3436ffef04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9285548f48a801a6de0af75d6239c42eebc1a96af4700851a61d8e1d0dba97d"
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