class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.138.0.tar.gz"
  sha256 "c53299dc56dbf7776a86d3802e928a8dc44a922b1bdaa1f1903d0ab8bb457201"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56c8970528f50a4398845eb53cab377f6fd0439d98b14df83fdf288fa94a13c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd153b282502bbd20966b7847e5bba50db797e98c156e9e6a65fc01313fb5e7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e81c99fcb0b10ac5080db96e0b10095931ecb363c52d92d6fd756879d2b27225"
    sha256 cellar: :any_skip_relocation, sonoma:        "331e8f2eee4d80be9bea99ce0ab8ae63324d0d329d995b86355147600b5162c0"
    sha256 cellar: :any_skip_relocation, ventura:       "0d14e68b4d1c8c176ea9c8bc9e2c23a58c0861e37a251d3c76797b7fd073eec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f124c350f63133eb4b7f75adb577beafe131662eb162d99d75ba2dd17a79ef0"
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
      field,type,is_ascii,sum,min,max,range,sort_order,min_length,max_length,sum_length,avg_length,mean,sem,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,,,,0,,
    EOS
  end
end