class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.58.tar.gz"
  sha256 "8b584720b74505f237f399739bd574fc15b0c43d9958caebdd4817e69389167e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccfa355a1dc2b25d3622319d1823afa63ac98dfb518136ff509e70b4e73172a6"
    sha256 cellar: :any,                 arm64_sequoia: "2a3f28cb0f879c55af3ff5aa7d2c94339de73ffa580b23843bdca30ec373c784"
    sha256 cellar: :any,                 arm64_sonoma:  "b60e3222f2de9c5e651ad838201e373871ba9e9626689385f14edbf3a0c898c2"
    sha256 cellar: :any,                 sonoma:        "bdfc6993334350b3d2e2cf617a66c0fde30392c96bd4a073dd64f2f3f2602fcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f974b89ff5958fe95409e883b3b9c7c82da089b74d98a65413d769fd78d1f6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "754068ecf63379ea2bdb0974883da3d1ac38cc9edf2271dd4d7b3a31374fcfb9"
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