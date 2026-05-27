class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.28.crate"
  sha256 "9e3537d18be7a3123ac20f60244ccb904dc1521145773c368455c2465d1e6a60"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8877c04e95e612ad4b0e86fba237c87962de329ce90a3a992769e111e9582ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0770e7805eb376de304476f0b58b53f96d30a388caa37346f5cae738d953f32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77d529b3a5e1a2e9c1117ebd2ec16b9322bde373e95dc4c21defb7fd0744d1c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "00b685e0f2d197e19723992a65f15fc28cf168a0cd44b910b69d94c07b86eab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e560379d48e73b09618dbe48c7f71eaab5cbbc650646f21f3ba4cc34be1b0aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f39a086837b3f2f2e4a3b0c4f2d90bb93a6b7b54a33626f439b3e1f61dd79ff"
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