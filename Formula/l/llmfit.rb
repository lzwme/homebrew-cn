class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.1.crate"
  sha256 "c76ed29f863bedbcb51990c9b2e69c0d6899d73c3027d765a974fc9af2afbed0"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8c142ff0ff50dda0d48a1469f496c81b78db570e0f956acc572421c65f4566a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53625f4f7d39bdad2600e3a98627e03d230403bd3f6f2aef3b110b1d28bdfee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2947c75122a0ed0159ac4f07fdbbbc34b93ce23f7e2d7c5ae0298ebe500ac7c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e869fa45272bf9851aa8fe9e974ee48109250b8ff56b2e12b8ad6d64dd3a024f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b8f7052e4fc640584abf850b92b44c8c1a5dc8adfeecc52e7335a6b2f804fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4141df20aeed942047d1d9f872e98d71a91e9e47b0ea8ae4c4f32da9e500646e"
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