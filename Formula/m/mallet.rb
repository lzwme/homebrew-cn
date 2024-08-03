class Mallet < Formula
  desc "MAchine Learning for LanguagE Toolkit"
  homepage "https:mallet.cs.umass.edu"
  url "https:mallet.cs.umass.edudistmallet-2.0.8.tar.gz"
  sha256 "5b2d6fb9bcf600b1836b09881821a6781dd45a7d3032e61d7500d027a5b34faf"
  revision 1

  livecheck do
    url "https:mallet.cs.umass.edudownload.php"
    regex(href=.*?mallet[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66fcc304b6625b390cd2ddb5d3ab99a3049c5b21789d3b54dcc18bf82fa3c009"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin*.{bat,dll,exe}"] # Remove all windows files
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}bin*"]
    bin.env_script_all_files(libexec"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  test do
    resource "homebrew-testdata" do
      url "https:raw.githubusercontent.commimnoMalletmastersample-datastackexchangetsvtesting.tsv"
      sha256 "06b4a0b3f27afa532ded841e8304449764a604fb202ba60eb762eaa79e9e02f3"
    end

    resource("homebrew-testdata").stage do
      system bin"mallet", "import-file", "--input", "testing.tsv", "--keep-sequence"
      assert_equal "seconds",
        shell_output("#{bin}mallet train-topics --input text.vectors " \
                     "--show-topics-interval 0 --num-iterations 100 2>&1").split.last
    end
  end
end