class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.29.tar.gz"
  sha256 "a9e2eac2a676441b3583137e8a0dc365e915b013ace931a99da78daf75bb9918"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03d0a1378e042b6fdca288507b9851ea80aab6251e15b1b8ca0d2a39227e49d2"
    sha256 cellar: :any,                 arm64_sonoma:  "7f2550b4ac16e55a3238c09cbe8a15bc2f74f7c894c92d25b3e1c6230ad55ed3"
    sha256 cellar: :any,                 arm64_ventura: "910ea2cdf646861331fd03709d0ca09e5eafdccfba2227522ebb3350654741ed"
    sha256 cellar: :any,                 sonoma:        "c871045cda7345c458dc040f91f39f412110bd4b2849d7cbd9393270ed09ae6e"
    sha256 cellar: :any,                 ventura:       "b714fc244094ef04863057076c93c0d8cdc253191a9efa1cb5fd351c68b29530"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "223d5c1f8cc702adfcc4e8689eb9715a9d2e12f868e98f3ee0018c1b8a04e4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa1702139fffedd74c90240d7356e38f6e858a4c1214b89b0d997463d58ba6c"
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