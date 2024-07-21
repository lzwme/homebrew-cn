class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.129.1.tar.gz"
  sha256 "feae013bedd3e48d194088c5de1b2364461fdc295423641b88426d356ad12c39"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "236be8e259593cc6c28137e8c597155e3bc03bea94d66cd9aa9dd87062d8820f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da7051ce9396db2e90a6d63507b98c00dcc12bb73da03c96c089bb207a5ac6dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3d21fe2b3de707b0605cab9def264914882117fb4a2dc569cfd2ea73c24d3cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e67c28a814d8370e08f99b604127740dc86c479e250a674c4fe6f3466fd4dae"
    sha256 cellar: :any_skip_relocation, ventura:        "1c0526d555ee46796c5b0c8471cfb77a2dbc0b8f0fed2948c9d690a10de3e11b"
    sha256 cellar: :any_skip_relocation, monterey:       "b2fc71af121497d3358cb567eb55fc3f002b7a51bc3421626cecb96723ff8d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1be6070d7286f72b187192d5b4d9c95cfc3741d832bc52280c1c4bebf399e398"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
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