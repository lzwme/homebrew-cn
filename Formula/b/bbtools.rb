class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.92.tar.gz"
  sha256 "d652a8e25bcff855da85b1a6d433e33db06e14618001f717148d5fee91e31069"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e70cbc9529e34229116b0ef6c9303e276f85657eb8bfa6bca478d710db6d96d0"
    sha256 cellar: :any, arm64_sequoia: "c2dccfb9ac6e97bbf428a891da7e57c5145e6f4007a134c5246211cec5b82c33"
    sha256 cellar: :any, arm64_sonoma:  "e6aad8d9d14d84c25226bcc403e7fb4235bde6f45a23d7ba0d07b9359cf267a0"
    sha256 cellar: :any, sonoma:        "87ab1f599493b28301e806d27571946611924a5cdd1320e21d3bbe2ad8857827"
    sha256 cellar: :any, arm64_linux:   "4793b34f795b2fd954dd4c02356307aa9f24c215925e6caf9e57175261278066"
    sha256 cellar: :any, x86_64_linux:  "92bc45a76cea71c3d86756d48e8eefad78ab3d53319b6ef5d24479ecd7014c78"
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