class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "39fc00fc8998c8c6b735bb56e815ed6c4621acf6d4794bcaecf5f1c09ab764d9"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07f77c479c2620bc374ff74447b47bf078b1425b08142061201a6a6ebdebfbad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5469d37c5fd63d4629fe5608af82d4b37d87ff7232925398735a1274354f235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb6258b1565f0ab7671c0d1d053f13feffe1083e722016379a2db0779134c080"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2c7e77aa61f3be66b0e23a1335566f6ab6a2aa634d411d7898db4bd9801741f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afe169e97a568bb0025c9089f4962e954fbe42cbc7b008e52d0c53f9e6d4bcf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ddaea739bd90a7361513251d1e15575d84488e6776b0eec1b575006d8e5240e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end