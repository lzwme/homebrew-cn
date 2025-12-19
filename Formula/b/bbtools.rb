class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.60.tar.gz"
  sha256 "b68d91f4e28d3830e3006faeea3ab275041a30d458f0b235404ad2a036630288"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee2f45fd12dea3ccbd246b50d8f3e7608791c86d5e540d4ad25d8e64572a6ef9"
    sha256 cellar: :any,                 arm64_sequoia: "8dac7720aa7d50114f6b899332a7e7c947965ebdc06f6dfc21a4a1974c924546"
    sha256 cellar: :any,                 arm64_sonoma:  "64f95ec734c18e210fc2ebabb113889e9cd86ae42f26b3907ed47c0bc52c0852"
    sha256 cellar: :any,                 sonoma:        "48404265d7e56cc4cd83bf0658325fcf45996717645772a5f7e4e32481f1e345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78d9e1eb0c3257d9d8e62504366385b56a63512433b6a0e2b5065545f49fd956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e033907ce581bb4f3b9f98027bff3c5dce5b00aee7615ae36894c6fe06aa53b7"
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