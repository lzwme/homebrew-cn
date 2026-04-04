class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.8.7.crate"
  sha256 "c85deb1c37a74d14c2f2c5fac82f55879e21a6f1f16dc7fd36dfa5411d5214a7"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "253fda5c942dacbbba6db78b904cf8a6f2fd1f23ab88a7e46e0fd2dedb81df1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e025dd18c5d787e3c6a4a8d850547c45088175e4006a0772523275dfbe09c090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e182576f32dfe5a9d0075a797b73d0bcf7e290f810c4d726e980b444422223e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "68b3d16608883b41def0bca205b93255dcc991e11e06361f6dbe02ad34c19393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc86192f92ef66fe112b666092086303660586546ea77747a511e2bb41411c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7145100fa70b7ce1c8cfb2e794b1130b7b3905384034934c19db9c09e615bd96"
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