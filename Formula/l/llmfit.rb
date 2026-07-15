class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.3.crate"
  sha256 "925ec5264aefb4fc5f4bb1f9b5395d4810e35606810b1209089504bc0134c773"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e1e6ebd7b1e4d0ca46e3f87e2920beb1bd0d709528d77e30855451a4d076693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f7eb99d22a683c72d5bc52b0303caf60760ba7f1c2f83b49e47eefd7c2d9e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17fb7b5dffa85d8c69326a100e55787918b820a098b1c57de30bbbadce1b9937"
    sha256 cellar: :any_skip_relocation, sonoma:        "09b08b4ed1f2bc2c156dfa3fbba0b917d47710ce227a0eadd45dd7399e414087"
    sha256 cellar: :any,                 arm64_linux:   "af50ec7e777e79d9154b7d4f9e71802c54e2ed10bd25e8c75819c716f70f10d2"
    sha256 cellar: :any,                 x86_64_linux:  "5066e90978c6919505e5cc7ba379e300e8dd278e8a6aa2421e916251ef1b24ee"
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