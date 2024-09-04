class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.133.1.tar.gz"
  sha256 "f2f59c07ea8d84d527641b6f6c2e1eeff114d04860d2904a2b85361ea62db204"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03f1b9b1d6540c5c7495670ee62e24aaaad216b3b9f68cad3e085b54b0f21933"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a6f269951e27a09039f7819afbd3cbf5f7518d5d713f0caae8a510788c58884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "150e561fcbc24aaed4cfe8aed36418f105d84fa5d74e91aa78dbe32d82a75fa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c86a92fb06c4027d0ed20f079e39c5846a8866a81c6663f4a23d0754362dc39"
    sha256 cellar: :any_skip_relocation, ventura:        "0942de9d12f07629420b041d71ee32afa868d066c426ccc92b48e5194cedef81"
    sha256 cellar: :any_skip_relocation, monterey:       "0557caad1d5c6b95f5036c3d5f7a4578645c8fb546cdf7471287b384bf7645c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4139205d7bf565cdb7d79289004eca2553c01395074cd7d7ec4da97f01875df1"
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
      field,type,is_ascii,sum,min,max,range,sort_order,min_length,max_length,mean,sem,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,,0,,
    EOS
  end
end