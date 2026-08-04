class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.7.crate"
  sha256 "165f5984a0fb5e72360454866f8a862aa72d9fac602b9090b4b2b76b76ed9e97"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9a85a38b590a2a94d30f49bcb3e001100dbc6c371b3a128cdd46f2535bb3550"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bde845b35f272cf9457e20b4826246225abba4962f8ed9309952a5bb18483dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fda0d340e32694273c844db8688a6627f97138afd514bd34828c9024d0adf103"
    sha256 cellar: :any_skip_relocation, sonoma:        "0836a24d0d08586ddb28bdaecb88470c893f621b4bf4e60dfd00a72bc37e2bed"
    sha256 cellar: :any,                 arm64_linux:   "e6f5d230757ce46e0e07d65ed0de8f0bc627c0a01ede7f60664b5bab8fc96123"
    sha256 cellar: :any,                 x86_64_linux:  "0b9496f1fe27f76466c49a01251cbef12be5e63adc7da72875607a79e6d5e12a"
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