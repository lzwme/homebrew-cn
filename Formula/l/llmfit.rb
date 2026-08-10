class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.9.crate"
  sha256 "db646a20cefaa6a870dbf2f7fb325cfa4e311b234d90ec64192b9f6b681e0b90"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91394f366a47fb4e8c3f5588bc0c89f2ded53a9f0d5746da7c314ecc74645b0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d360a8bde4b3e958d86dde615fe08db632474e4966d02487ea5d31e0a28e4424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0038eade745842115d1b806a5af171bd64806abd0016458f8d2e97276eda2ba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b924392b91fb46f02360bb3db722a1e4b7740d33baa7609ddb55ea7dc6f0f50a"
    sha256 cellar: :any,                 arm64_linux:   "466273d7d9e76c2a193fbcea743eb79b3ea0ef90beeb1eb6db462555eaf9062d"
    sha256 cellar: :any,                 x86_64_linux:  "eb8fdcdca3c1b7bc19965194cdf59da72090ee1678ed3e18d62f8c2938044113"
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