class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.86.tar.gz"
  sha256 "b08c23b44adc5d71dfa41ddfbd84f5866906c3d5cf2c16c6615e077a78298024"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c8444f550e36be68d4dd40228e6f8eb53ebed0849ab982146f6bcf685e37b23"
    sha256 cellar: :any,                 arm64_sequoia: "9aeade60b2de33b4c2b81edd9586faafa331b706969a7636d8b1542fcc5a45b9"
    sha256 cellar: :any,                 arm64_sonoma:  "9bc51248e6c1d489d0a1f76c16748613a45cfd0ff81fbc5986d37a1a77dfdaff"
    sha256 cellar: :any,                 sonoma:        "b1b5f256fd79f00c2453a4e7114d788a669575f61f8ecb9ebdffa337747b5bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "348d3b9005c91def1a456fbe0ddc588cbeedeb0a1fe1bb165406d3f951129a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7909d35fdd2ed7a14b784869f633983337df413804eb1ec62d44860c5a2e371"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[bbtools.jar jni resources]
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