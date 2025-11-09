class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.46.tar.gz"
  sha256 "f1150838e80b75bd0d6d001d5c6656f2b3907475edd6df82ddc89cb83feb7f3d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3975aff3479503eff25c9372a84f0f3a5f05a8dc5e5008b9d097dc5969787311"
    sha256 cellar: :any,                 arm64_sequoia: "4ab78eee90eeddff5d3002ee69f2c2436bca68e19dd9b040cf9b36b5bd784314"
    sha256 cellar: :any,                 arm64_sonoma:  "1cc7a10614a0dbf35532dcdc46fcd580900ae02dbd479f8523ae044895c4aabe"
    sha256 cellar: :any,                 sonoma:        "8fbc790e22764196406a870e43f15f7657024e0cdb1ba3025bd9538d84eb6783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9401bb75b35f536e8eb5660deed45ce97de1107a3522a43e9d303fcb84f5c205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cadf5168497c925a9b1ac379b910fb6280b7e2faa6f8242c67e9adc7705f77c"
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