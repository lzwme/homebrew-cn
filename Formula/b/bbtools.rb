class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.73.tar.gz"
  sha256 "49a002bd0692bd5781e2866fe88c5612a12e55ba8767f216a8e1816f4a785c61"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8be45be47df2c6b66c1b3ba528d76c77a3979c3d90cb26e73894c3d802a51a8d"
    sha256 cellar: :any,                 arm64_sequoia: "93a8f82ad5d7bd06c998a4cb365f72dc5e40eea753d8b206145911f8a80a6adf"
    sha256 cellar: :any,                 arm64_sonoma:  "901edc37540809ec3b156cf14f927e1658de4a9fea2bfff12745e2181817a11c"
    sha256 cellar: :any,                 sonoma:        "84e2abdd9ca0745a7e564582a3956df4cfdb4ddc9eacb24e2526f66ea0ca3df7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ec62b0526c171c8da4e39f3705d7d814e1a8f3969abab1da8c125c873024d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a8391c045323bbf2bbf620700c7382e3bc749e09f207fed213440d23cbb2c59"
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