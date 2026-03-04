class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "5fe594eabdbee3a4bf622a999e823be756c77b7065bb9029794b0625530ff21c"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "744c545bb0f5e4f92c6dba6d2849543bfd73bce9f3a586584d2c5d6695b7db61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df441591270a60c644667a64b916b8ba89564450d73b42c4b40283efcb07e472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52260806b8ee08d6cc9cc5a1336c3e41c83b87e97591ae62599d8489e908228c"
    sha256 cellar: :any_skip_relocation, sonoma:        "366752cc22ff00b904ec31fc855859716c7dc779f756a479f661c7a280d8fd92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b1f469943870cbfce1da077e0b73ba3dbe7106ba402faf3b1cb17005bb1f053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "935d258c6b23f508d5c09086fc006f12763d54c0005799b9b85d620063af2d3b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end