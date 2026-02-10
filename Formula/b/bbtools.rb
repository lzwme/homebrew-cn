class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.70.tar.gz"
  sha256 "39d1bdd50621d463cdcd85fe1b94c6eb6fe9c1f2aa77541fe1640dcc47275bbe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a9a072ed660da2d300f2edf914ade59110ec680c17d7e78218dbad26d613303"
    sha256 cellar: :any,                 arm64_sequoia: "c787f38e3b88db30a4ee1a2339b617c5b32650b42881f500ff6452a0a0632379"
    sha256 cellar: :any,                 arm64_sonoma:  "2f13bc9f368cdd679b1a2eb416ecefa0ec05977ba104a2e00451dcf5676c4bf5"
    sha256 cellar: :any,                 sonoma:        "80d91bf69e67c324c242c0b27d41f1a3cee3c7cc84e551a31a548d8851018b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed28be098203e9d92de07e71b2d83a2a718ca77910a7adecc91debdb624fdd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6552c22b6d3ddb4c76f2964b09667f5ca53a03d75913622093cebb34fa267acd"
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