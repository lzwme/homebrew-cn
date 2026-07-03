class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.35.crate"
  sha256 "bbdc0c09dd06c7989abcd3ca9ce17bcb24bc55fb095db36adbc3fec138f373d2"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91be817e2203ddbef7d92d5cafcefe2c4d9c477cc6c07d92faea555a53b06535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8212af323788660a2c93d8b07bd7edf7db36df58bc31c667e67a7ecddc969cb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c097645dae0e9cb1c90afd2a434db0f668109a16ef4e0f90611c611650f59d4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "45ded6cbbe17849be1c96b05f9aa7abfcb5dd4060fb6da487a6e2977186ac5d3"
    sha256 cellar: :any,                 arm64_linux:   "ab0178c11a536756b43c93774f2b1d22ba4643d3de7ccd496b9150af32565bcf"
    sha256 cellar: :any,                 x86_64_linux:  "7309a60b96b6ed83771df053516a1602c2563f3e583fea9a6d6ebaf1d2927c84"
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