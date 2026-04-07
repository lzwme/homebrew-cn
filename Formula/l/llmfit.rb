class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.2.crate"
  sha256 "57f6c6a9eebe35620b0a4d7e133930e10c5b7607c991fdcd4009b9acfc05a725"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "196118aec8cbb5d96dc6dfe310f637bc2ca3d6124a462eb3a8cc2432923c0afc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "971550df7985e9abbe92ee280bc8f7ff36f76ce21652fd3b540906b44c3c1055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "433c7dfcca5399afe934dbc0f3cb7a3dec76bd9936347cc17cce9d93fcf19dc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "02891d8f4b57db4c48f928c8c66199541c1c1419378c601b7f4613de748d6617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ca0dc69aad9b1f1f6c816ff1ca52081c32c39017181ba59df6f4910cbef3ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8461c3110aa6af51e21ffd1a60379e0a8edc07959a7c8241f12da75ca2315883"
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