class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.134.0.tar.gz"
  sha256 "276b34e830564daf3a7643855628ceda4379291c7818076a8f8648ebc9e345f4"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2e6bf2115a56ebd6479f4153adc41ee87ea6f819d0e296a446b7ae503e226fc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5420a6f66509fcb9d4ec32b19d819afadf0d56e813255bc35592af2a49046975"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3829930d8fcfd5f1f23a5b96e21e61bea7672476c0af093cff52df1119348a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53ec1c72dcef55b58810bac1d51e259525d014c9fcdd6525692a373d5adb3d4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d68237a0f040d865daf418b50f12222a81a0f71da4ef320956199853db323575"
    sha256 cellar: :any_skip_relocation, ventura:        "dc477aa69ead83285fd835be6ca3c95d44cc7706f1a38e5e32528410985066d7"
    sha256 cellar: :any_skip_relocation, monterey:       "009fffa6336c1b118076d2711466974dc6c94d8024344c0195e011822e485669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7000cdf2d9fc215043e0613ea777c5411c620607d12fff3b82d28dc2e97a1b"
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