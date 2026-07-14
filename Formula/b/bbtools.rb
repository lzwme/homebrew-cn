class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.96.tar.gz"
  sha256 "e173bdd0d3ca047f378c71dad568a148596c1690bf36abca93e918569c9fb382"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "928b87c2aa2ea2a142e6df091349aec4b1fcc0e003aa9421051865233d7d2387"
    sha256 cellar: :any, arm64_sequoia: "1cb013598dcf3e2ec72eb7987631ac3bf1c521c265bf3ddb9e862a46958cb916"
    sha256 cellar: :any, arm64_sonoma:  "9c94f8f0570f80f604d052835efe4891a9d8615b5791276144255be3cc021c97"
    sha256 cellar: :any, sonoma:        "810b6ff1db1deccaaa994cb4dd8effc331ae5009910cecdd224de6ec7023184a"
    sha256 cellar: :any, arm64_linux:   "d21408eb4394ec3fc9a02bbc0e32b436e5f631fdf2e7148428b9a1c95c00a317"
    sha256 cellar: :any, x86_64_linux:  "e8b82fc0e96082706cc5d7c934246835bb1a6b83bd87754b35731e84ed27167e"
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