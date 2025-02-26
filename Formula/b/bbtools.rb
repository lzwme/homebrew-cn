class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.18.tar.gz"
  sha256 "6f861ed582f8534e5383f9c565080b35847834d5dd7426fcff1d401e4bebf2a3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "feab9e1e4886de5c54dad08d52d9e752f99a9a30246f63d5adaacc2b7594aac0"
    sha256 cellar: :any,                 arm64_sonoma:  "477598f83c134ae149911278709f59d82dd86cfefacf9a415bac74a273c24676"
    sha256 cellar: :any,                 arm64_ventura: "983b99fa260afba121174810ed3a8cf4384ee96ffd01b08ef221b0f8da668a8a"
    sha256 cellar: :any,                 sonoma:        "d1c1ae652071dd0f2ab68626bc9c7f427a5fd2172a90d2e2ae9104ea4191466c"
    sha256 cellar: :any,                 ventura:       "da3fe894a5a87a2b66af5e04f5410e41e0134aeb47dc1171aeaee47dbf074a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3911d395df5a42d5bbe6590917f17d887c1668eb4e9bd59fff58486013bf93"
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