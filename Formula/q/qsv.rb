class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.135.0.tar.gz"
  sha256 "de2bf3ba3d0f4bc71a2628cb558e878da24e312c9addcbe3958c5169540d980c"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec14051a3490b3e62d17146bbe81b1cf1f809610976886efe5f2981697f0f76d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a08f6a596a28787289e045c173576cfd30bd81705b1916842fd19046aa8c6d8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58f746661889ae0d1a58d1d91cef2e455a99a49763bc8b4613de9671572d518a"
    sha256 cellar: :any_skip_relocation, sonoma:        "047fb9f90eb501c7c7ab6bca1d766212143496176dcbc96061a007d72b20388d"
    sha256 cellar: :any_skip_relocation, ventura:       "3ba695ad12f15dc8591866f848e7032ba7738a9f9a86edf2030c654bdd48e0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985c11f31db0f95f557129d6e223b0608b4d3d8b85e04ab5ba09bd083f79616b"
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