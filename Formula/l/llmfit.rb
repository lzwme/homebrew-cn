class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.37.crate"
  sha256 "13810254e6d275e72f7d6c554fe0da36005aed060cd743d9e0a1e0a9ee5dd251"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89667ca457067813286221bcb2d21aabb014d495c3f7e2c4b7b4bdcfb52e553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b1e58cc8c79b5645eeb848783ab8fef8fb654ec953e48dab0c45589ad80083e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42e77b41363b87ca46ab94d5de958fbe61c610c63373395ce740c081dde59af6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8b8da182cf3427233027c4be5795a31d3e7d5ac3f1c6095847c070d214ac0d5"
    sha256 cellar: :any,                 arm64_linux:   "48eb2d8d8b9e78a63b204e9b7c0ef32685844bb9f486058360c26b31bd2b62f7"
    sha256 cellar: :any,                 x86_64_linux:  "14e2a985cef645d7f67166f954552056add83a533f9e6b558a38b6111b334983"
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