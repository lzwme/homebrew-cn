class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.50.tar.gz"
  sha256 "4f6e34835cb715df6edf7b43de7514c50e9dc184db39a9f5e7f2e34060548f2e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4671df2d18f76251a4925534af71099424d02eaa673a524877e9106cb86f793b"
    sha256 cellar: :any,                 arm64_sequoia: "b9ddbebcab76deea4d12e1f0f86d91297b47a52b71d6de032ec77c6fdd05cbdd"
    sha256 cellar: :any,                 arm64_sonoma:  "c7ceccb56aea810a2bcfbc483f5ae41a5de5c769c3b52006cc233403d73971cd"
    sha256 cellar: :any,                 sonoma:        "f3e50e942c161098737eb24ca852f92fe20e07024318f252a97293fafba9a4b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c89b95b52a3f764e58e230117606186ee7464bcc954f728bd282181d5bb40ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2d9ce95be50b7ae30db8691f79b1d9920ec84bb99a54254d5ff0252691570c7"
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