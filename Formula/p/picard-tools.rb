class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https:broadinstitute.github.iopicard"
  url "https:github.combroadinstitutepicardreleasesdownload3.3.0picard.jar"
  sha256 "58819a7660646b74b34e282f5d4d21c8dbaea22ddeff96e3258755dafa0f86dc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "706381105c8a7bdfe612eb03926a01c5ad852ece5a7ef4f438e9b8eb07debd14"
  end

  depends_on "openjdk"

  def install
    libexec.install "picard.jar"
    (bin"picard").write <<~EOS
      #!binbash
      exec "#{Formula["openjdk"].opt_bin}java" $JAVA_OPTS -jar "#{libexec}picard.jar" "$@"
    EOS
  end

  test do
    (testpath"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      CTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    cmd = "#{bin}picard NormalizeFasta I=test.fasta O=devstdout"
    assert_match "TCTCTG", shell_output(cmd)
  end
end