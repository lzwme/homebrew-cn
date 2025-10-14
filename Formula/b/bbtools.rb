class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.38.tar.gz"
  sha256 "a6d3a9b18a3c9228e7d7a570a9f3025237a6fd16f47ee850e5c11caaf15a9aa4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a75cf145936023cf2e8900dc130eabfb161f5c2e7915d6842739afb49754dab9"
    sha256 cellar: :any,                 arm64_sequoia: "a3c9ebe2320fa4bc94f07d97ebc2224e070b6730acd0b791d056ffde1221b7c7"
    sha256 cellar: :any,                 arm64_sonoma:  "dffe7f2f5dc0459af94f5e08e681f760115372d9d5754b7ff2346d21281df2dc"
    sha256 cellar: :any,                 sonoma:        "e7aabaf88815049afb4243f6455c130357bc16da324c2bccb39623d2ff9975fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adccd967830d1513b7e449de05e281aa47f71e9242615222a2e176eb257e1147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961348c7f4413706fe54e8c1d0e1cf31f010601dff40daf2d3c908ea66db829f"
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