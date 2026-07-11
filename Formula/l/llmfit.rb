class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.2.crate"
  sha256 "eaa5fbc5db11962b58b84c3b71fd49df884c7808e6bf49f5f982d84f4e21a021"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43e508f060d20d0f945a1386bb544d2325c9c507f88925bcd68dfa0977f59b4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd2e065039e74afb12b13ddb6429aa4fd20a8cf4c4746c53bc08486faf3374b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f256ce73e71e205c8466084af3e3f241af12ccb8eef161c5e05de039753cb88"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a1013abed80f316176a73f3f33aab262032afcef1c79899a9a489f5e701bee2"
    sha256 cellar: :any,                 arm64_linux:   "30677e5ee1857d202e33261a626d0c577dbab11dbb8211d92bf15cd9a8a0b110"
    sha256 cellar: :any,                 x86_64_linux:  "69e1eb0e5d79ad764efa969ffaa6a798274596a22671dc35b50d6b6e59f32990"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end