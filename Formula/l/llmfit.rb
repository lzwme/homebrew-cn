class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.12.crate"
  sha256 "01cd443d80c29be355239fe3566f320f6bf3522ac0572011b0f6dd56e70c9793"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a270fa202d275b1573ab4b4ed134b481ea38c49cce736b3345fb1466722a720c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baa491ab8abd45b25875b854b4026cd788944ae446782eef315efc8a47dac30e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b99b590c304b52aa24b120762d177a38ae8479c0abceaaaf4daec7ecc6c85d7"
    sha256 cellar: :any,                 arm64_linux:   "2129b67fb825b82d2cfc0a38ebdedd8fe9fa479fa27cc7bbe810db34f33b524d"
    sha256 cellar: :any,                 x86_64_linux:  "1e639610a97558ac96fd92119306ea0478236ca5e5b74f8df084cfbbd51df929"
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