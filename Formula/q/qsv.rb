class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.129.1.tar.gz"
  sha256 "feae013bedd3e48d194088c5de1b2364461fdc295423641b88426d356ad12c39"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f74e44008d43492b8c5267aad808c82aeee5b8a3cba377eb82962dc66175f342"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba70c9299cdea7200498ba4e585f29471566565c03ebd46a0502e0165d22b926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d4636829bac3abc7cdb9640cdf149e366a2b68df44206ba34cd7cd0c4402143"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a71e1cd4d42b01bb2dd71fd09cf71e748e202840d1b3bc226967efac73635c4"
    sha256 cellar: :any_skip_relocation, ventura:        "130ef072b7d1b6dc070ce1a8af180d948bd6235030593c13a5afea810f5c7336"
    sha256 cellar: :any_skip_relocation, monterey:       "c78b494cd9ccb8007b07246e18dc7b3183a3112f7decb12da7a2b8d77430a08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262b0b1312bb2c46f1ca6cd0edeb6a3cc481d0b085ddc405800d533276437572"
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
      field,type,is_ascii,sum,min,max,range,min_length,max_length,mean,sem,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,0,,
    EOS
  end
end