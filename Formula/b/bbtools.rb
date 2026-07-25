class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.99.tar.gz"
  sha256 "ad3224eb6369cf86e10443b84465de2f51545fd09ba31f5a0b1eabe74fc09343"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9e67c1d0666ab03c1a6f2deb9aebe501a25b23363afadf6005ff7d6cc57de006"
    sha256 cellar: :any, arm64_sequoia: "6ceb3622fe6f36d5567b696a82c3bd6d400bc5805ba1f9299a44beab8ab78c04"
    sha256 cellar: :any, arm64_sonoma:  "13569f6e9c82d2229faa363b132eb6e85fd8ce1059b7818d0c695877a260d5b2"
    sha256 cellar: :any, sonoma:        "d3e50415f91ce88565691b744d1e464954c4f80880440071173e8dd9c193586f"
    sha256 cellar: :any, arm64_linux:   "422f9bf445c1ed320309ebfffc553bef616be4376fe056a2e66d7b44e12a1b94"
    sha256 cellar: :any, x86_64_linux:  "af94622d200d6dd041485122375587cf74b9c999ced80d321a0e427a4feac5f3"
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