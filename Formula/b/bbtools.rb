class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.56.tar.gz"
  sha256 "a7fe452553f502e1f0c4908c0d69bfe97218217979619a7de89ace3f1b2ed7f4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85fe087a06f3e5446a62e981945dcd86880b71f95b138cb437cb8da65fd93135"
    sha256 cellar: :any,                 arm64_sequoia: "bf0b6ba9acff2dbdc1a198947853d08127b08e463e866a6b32a3115cee2ebf41"
    sha256 cellar: :any,                 arm64_sonoma:  "3abaa61499b93191e50de4d2c8cc50cc29a8ee556739ceee439ebc294c36d4ce"
    sha256 cellar: :any,                 sonoma:        "bccf941ba6e3b38d81d6fa816d7b024ffd1ccb87b079735835fc0130a7058bc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d0e41e9c8a626f5d4c8affd530838684e3ded6f048997626e25037fa235c601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3090c8e4ad8d0ec6a8ab3c43ede54af3acee41b1a73bb8483e58764837336dd3"
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