class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:qsv.dathere.com"
  url "https:github.comdathereqsvarchiverefstags3.0.0.tar.gz"
  sha256 "25d2fec81e027682c3a67b5d3088082df77a899c946fff423b0f969353b7968b"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comdathereqsv.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad4431438657d829e177424596a30297a62a04f62ceea84c3f263d2ee060ec99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa49f312daae64ad05689c7039a8848832d450d8f21b4e74320afe870bd017ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e611bd114d48eceee0ddc4215aea7286c719a1a7fbe5623a185cd146a9f60d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d4a7c27c3fc9adfd2efe194ee94e5a589e56a769b5adfe3f8a8c709ff7ead4"
    sha256 cellar: :any_skip_relocation, ventura:       "6f7154741c4f1af077f87df4eead798018d08cc19e443455f2187cec1c10092c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b123f993a9d9990368fa962c29d9c76f519d86e857ab43ddaceca97c391ab72"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
    bash_completion.install "contribcompletionsexamplesqsv.bash" => "qsv"
    fish_completion.install "contribcompletionsexamplesqsv.fish"
    zsh_completion.install "contribcompletionsexamplesqsv.zsh" => "_qsv"
  end

  test do
    (testpath"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity,qsv__value
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,
      qsv__rowcount,,,,,,,,,,,,,,,,,,,,,,,,,,0
      qsv__columncount,,,,,,,,,,,,,,,,,,,,,,,,,,2
      qsv__filesize_bytes,,,,,,,,,,,,,,,,,,,,,,,,,,26
      qsv__fingerprint_hash,,,,,,,,,,,,,,,,,,,,,,,,,,589aa48c29e0a4abf207a0ff266da0903608c1281478acd75457c8f8ccea455a
    EOS
  end
end