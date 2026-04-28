class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.82.tar.gz"
  sha256 "d0f5af6926463f4c19e0d0aec4e08fa6e44cd71f1f2d41cf19fae7801c9649c5"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53d673ad5ca92b9dfc1bfda263cb33dfe46f5195976612a72b12816ca857e06b"
    sha256 cellar: :any,                 arm64_sequoia: "ebc05d8031fe4230514bcf9168e30abc0081c4ed176f81237bde537bf677a647"
    sha256 cellar: :any,                 arm64_sonoma:  "4e6d95eb74a936898531f14fd14acabdb5a7858e45adafdd57fa92a0a9760ea7"
    sha256 cellar: :any,                 sonoma:        "7740bb4b790996cb6516e2497e7771c3ff52938e3db48d9536fc024ba938500d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f4f965219882a14612a85a4b2ac0c5476a08795a14c665a27c8cd36ae6fe12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f8419218ef4d00f7c4511b0ffc3b48b85514d234cb3b3a8d66801a109bac0d9"
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