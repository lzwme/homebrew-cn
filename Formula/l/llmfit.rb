class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "0305a73f83c0002c440a8ad9c1b5045d33f1d3388f870811ac4c48b71af366f9"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ef856a5ffdc3f384bed46a9090f45f5ae01d3c1a8802b98396ab2d0144200fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad1c3ba36279c0efa9db7750b8301a6abc2a89549ba2838b267e9c660f2e2a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee8e2926ac726054d10e9d468aefe6e161da12d07d720959f5f4c7d7ab22b53b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c1a1cfcda7a9df5b349caff3f82e52228e15940ae438aab915ad24aa430cc16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae2cba15ccd7a810957813a3cf3a14625d6302e007ab313b48830b15fb86ff95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e490de02e3e0d0dc2a80373690b02a5c8efd738963aee2c03d4248f3755ccd4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end