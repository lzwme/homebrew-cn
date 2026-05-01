class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.18.crate"
  sha256 "94ec89e394040221dfb43e5ec6671a1f1a2e1b340c676c0bd7869ad9708d9249"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "828c0f39dd1f3567bd1239d0307575f3383224a63ec03bfa56f96b78b8000830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19a3e96c96b565b18225e74f778276d302a58d88208bea1ffd2157c30d2c0e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db96591cf55aff592fdb6807e87e2dc04b43321c8d562ce25ef8221f9544dbd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d321788e9ba0b39418110ddd679c50d0bc7e06b0250aadc700d91a27596b5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "088310d85ec6c70a6173b06e5d045c3bdd98615f749056d3f18a9244c29f37a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31a0426517acf3b81ce1c65e60cf5ec3d45662b869ebc489fdb15da8ed89e434"
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