class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comdathereqsv"
  url "https:github.comdathereqsvarchiverefstags2.0.0.tar.gz"
  sha256 "499820c938e2c9cdb9686cdd02ab7a31e207e9fd803ccc720b5e5ce09dfd7cd6"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comdathereqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b0df2442af410b80010ff676dfdfd317f36777d945339fe2852b8d98cbde152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb0469653d3ceb0c12f45d5289397e6273493b546eeb397f1a943ec1aa11c92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac04ae6b7401d0d4dcf0aa97fe334e3344f4eb5fa6c1035121d7fbd5a60efc9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "be8d55c5997a98f0722dee1b6ae2b3b0ebca6678034588e561207035654d47b8"
    sha256 cellar: :any_skip_relocation, ventura:       "3ab92df106f5b060116ea094c4575d9752ead76eb030daf4ed250f32471e94f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3bc2cbb9dffec4beacfd8462131a92775ed87025ebd764ffaa928fe26c81f73"
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
      field,type,is_ascii,sum,min,max,range,sort_order,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity,qsv__value
      first header,NULL,,,,,,,,,,,,,,,,,,,,,0,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,0,,,
      qsv__rowcount,,,,,,,,,,,,,,,,,,,,,,,,,0
      qsv__columncount,,,,,,,,,,,,,,,,,,,,,,,,,2
      qsv__filesize_bytes,,,,,,,,,,,,,,,,,,,,,,,,,26
      qsv__fingerprint_hash,,,,,,,,,,,,,,,,,,,,,,,,,b818de06455146a422a60ade18c7e4ee5872089c79c32fd8a87a0f05e79564ed
    EOS
  end
end