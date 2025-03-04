class Fgbio < Formula
  desc "Tools for working with genomic and high throughput sequencing data"
  homepage "https:fulcrumgenomics.github.iofgbio"
  url "https:github.comfulcrumgenomicsfgbioreleasesdownload2.5.0fgbio-2.5.0.jar"
  sha256 "902b73a4eca6e6ee0ad4c4b929983d39ed69b1b1493d398a7a21b1166721f0d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4dcc215e5ac89dcfaf94cb435f9bf31ef4efbc24a073aa47373ee1ff557f07d4"
  end

  depends_on "openjdk"

  def install
    libexec.install "fgbio-#{version}.jar"
    bin.write_jar_script libexec"fgbio-#{version}.jar", "fgbio"
  end

  test do
    (testpath"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      ctgtgtggattaaaaaaagagtgtctgatagcagc
    EOS
    cmd = "#{bin}fgbio HardMaskFasta -i test.fasta -o devstdout"
    assert_match "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN", shell_output(cmd)
  end
end