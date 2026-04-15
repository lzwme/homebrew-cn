class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.8.crate"
  sha256 "367c98586944ada8bd0076c38e7d7a99782509908799fbddf5d0cc11779bbcf6"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76dbbf0010fdb476f5abfbd4078757d8aa79d2bc2ab06de2cd78369001c472a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3017b9c36c702a82c4b00adce553e318864a656cdab98b09a2708015e231c7cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aab42ad6abbb9b7631a47bbc4073878db565bd9c18cb951af0becc83c1a8527"
    sha256 cellar: :any_skip_relocation, sonoma:        "da0d7d5b540fa3ed4004d87c14b894b936e5be95ca68919f6092d7ec310c8d54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57b55665e4bba10a76666c814301a2c9ac54fe63e5ea75a2164bceef86276af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a10fed78a154e4f1178f549e1cf9d15caf7b6dfef7730623ad28a4fba217198"
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