class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.31.crate"
  sha256 "b66fba5d2108bdbad31d26c6475c45338e1621d16065ec3a9c4d68cdfbd07662"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2857dbb6bde322d57471ccb85681e9e4003ffba34a628bad5a90847960c8a70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a79174fa29ac7f373e9c0934ebc2be9c2a8e9f0633cb1c59b8ad1b18aa3ffcd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8914c6e05120402c43a4381c78e80615ecd0594a5a527ded1df0de938b2dc16b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a76637ad63b621c192b1bec04717af8b65438e3d5914c4edecf5cd8f298f1000"
    sha256 cellar: :any,                 arm64_linux:   "272907e290e2818ec18b6b88d3035c78733cd9390979383fc2490f3a10762a60"
    sha256 cellar: :any,                 x86_64_linux:  "e0f2cfd1de3765bddf9370e1a2b3db49fc3b4d013d5f260df7c9933d7e112526"
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