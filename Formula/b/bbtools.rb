class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.44.tar.gz"
  sha256 "15a12de114189f33a7e6984779eb1a0a8677be129dc1b25c892f32d33f06e682"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f988508ad01ecc28e2b3f2ed1ce795c607b82ba89691932ab48c34b5227e3cb"
    sha256 cellar: :any,                 arm64_sequoia: "d9ba8a18701659a82d94c234dda3031bef0e3fb4f28fbef0580d983cbb54809e"
    sha256 cellar: :any,                 arm64_sonoma:  "324a9cb770417926b200e8cef6a23bef2a649d12c727858083d1a2dce27155ff"
    sha256 cellar: :any,                 sonoma:        "c658f953c98560401ce1ab53b47333ec2ab96fe93b99cfa2e709f902f3a85cb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f9bade56c51884b2034bfb99265b803d236540d0b4890e9b5454b9f22fea562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a27946d68110c06c93b697f00d8ede3c00c68b1d8499c2e5e1a4794417d0cee"
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