class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags1.0.0.tar.gz"
  sha256 "92ca4fef2c0f58aa5d322a01a70a7e9dd689f8055cdf64aaf1422cb28fe5357b"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfd65ae7bec0ad2bc5088fa2ac7013c1eda71326568c6f8b33f6ca596bd08929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24d543706a408c2e9c06e3c40b73c164d2ddaa66c8172f1d6141edc7b60875d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7cc215c5b7827df8ed0c672243a7648a4aeda21c1671efc50a8251c8e7f363e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b43b6d118781cde8ef56cd40b604f91765a0dca12a9fad4c8eaeef6ee9096421"
    sha256 cellar: :any_skip_relocation, ventura:       "4fd97de6e88658dad19ab38a290d3ec199823da0ed45110edf497b57911447a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a4fa1ee8e48b4065a9959d5c5b29f6e1db2647d6bab694b7e3de43543dbe36"
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
      field,type,is_ascii,sum,min,max,range,sort_order,min_length,max_length,sum_length,avg_length,mean,sem,stddev,variance,cv,nullcount,max_precision,sparsity,qsv__value
      first header,NULL,,,,,,,,,,,,,,,,0,,,
      second header,NULL,,,,,,,,,,,,,,,,0,,,
      qsv__rowcount,,,,,,,,,,,,,,,,,,,,0
      qsv__columncount,,,,,,,,,,,,,,,,,,,,2
      qsv__filesize_bytes,,,,,,,,,,,,,,,,,,,,26
      qsv__fingerprint_hash,,,,,,,,,,,,,,,,,,,,1d0c55659105190da4e4e4d2ff69ae40956634c83dee786393680d9d02006bff
    EOS
  end
end