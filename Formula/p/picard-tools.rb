class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https:broadinstitute.github.iopicard"
  url "https:github.combroadinstitutepicardreleasesdownload3.2.0picard.jar"
  sha256 "e258fa2e3f5fa61cd6799ec8e073f49a95fbdceaf163d8a60971b2619b86fa41"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2bf0ac75316edab4e75e2325f166b4f30551043d241de2f97604876737f162eb"
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