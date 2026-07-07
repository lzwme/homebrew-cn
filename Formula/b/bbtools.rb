class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.94.tar.gz"
  sha256 "d1f89563726506265dabd6f261b4e96354f0f9ba1697781b03ebe327b1000ad1"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4fdfa3721501833b9f31efe6dfc6dbbb630d4985a70c20334b660f69a07e6b94"
    sha256 cellar: :any, arm64_sequoia: "978ec3770aa28a6cf3675aaa1e8e7f509ec58c3f8ca411b3653a5292d6460dad"
    sha256 cellar: :any, arm64_sonoma:  "4e93a35629f5a6e72db0e7073fc3a651fdf4863894688fbe6bf12125d8b35151"
    sha256 cellar: :any, sonoma:        "bae8c1021e4d004cbb9ffb18d47f701cfdc82df2207b659d5c46a538fea49067"
    sha256 cellar: :any, arm64_linux:   "c4bcec196d103ec008ef6f7f05eeaf0eb1dd9e598c4ea7d3b4ee0cbc707d2700"
    sha256 cellar: :any, x86_64_linux:  "e95583012c085c51d0cb961b448b7e6e3b25b6a2ee979bde4b44266baf3e215c"
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