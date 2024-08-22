class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.132.0.tar.gz"
  sha256 "bc7a1405a1543a6930d3478d80288d213acc3104a0510a7bceffc2bb32b972e0"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af643422ddee55a6cc783eca2fa351ab527e6835317f46d241553e56ae6a1441"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fe6cb0a13dbf5dd8134f39ad4393e0d7e51f8ef48f5181e9a3655ac64ab23d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77eb8460a847326ee2f9c50026ec428274420b5a2402f6db99c98aa9f34f0d7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0429b59d25d798bf4a765f979c8ef4f7a951775fc2c73e304858b207c475e24b"
    sha256 cellar: :any_skip_relocation, ventura:        "cdcdcbf91271b9e31070bfcf9e99e49b3d1ddabd1182be729a8be1f7307fb358"
    sha256 cellar: :any_skip_relocation, monterey:       "17c0620390d3c95c91c3a101609b6e460a5fe5dfea93fa6d3ad408b217c0e522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ccc677914f5662dc545176f5c9cff395f50080a2649bf0a800ebd36f542830f"
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