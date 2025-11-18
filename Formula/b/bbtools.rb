class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.49.tar.gz"
  sha256 "ed39fc101639586a3c1183832d5d5a56275cecc58af65a1566801c02120903e3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba4bdfed262265123c92886461e2c0888d9ad3174ba9c47a96a2ec122de529d4"
    sha256 cellar: :any,                 arm64_sequoia: "f9901cbbd7feaa9bee86ee8ac41fe72c92098bb5c90ec75594fd26086f46b01f"
    sha256 cellar: :any,                 arm64_sonoma:  "a42574d34710c459fd1a0cf43cb73b69126927cb61e2cc9fb609a28c222dfb22"
    sha256 cellar: :any,                 sonoma:        "e95b65fa46843d39c4b61165a704031dc73031cdab6e723e56bafead4335881f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ba18ed60b51592e824dd2dfc5506ccbb547c177b222d22708ec8ca76b50a913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a64bb9cca2b000dd4811b166e1a4aeef9199807fc22887d19b795a0cef0be48"
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