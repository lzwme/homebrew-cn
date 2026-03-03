class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "8e99895e4c96bdf53721912aec4c7e394120b955ae52652934ba410d8e27812e"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "673f448ff06d5a31f979b1d00ac39584e08193bec37a747b5a8ba91724e6202c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d066930df80b73e3115423600ff7f6d21f7af0af1659c8d1370d46c754d638d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2b7939655866bacc46e7aeb734d5be9c379c8cea4faae968b5ce5a44e9a8776"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ed685f8c88717e5da340eceb14b178198015811851186c7a873a30cd80db11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76ce5489e43b799d6a851059d2058e6f82b43b261423a6f0f69386680ff428f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7b2abcfa959363dc1649356329ab5b88165808a60edb585927b09083e44f31"
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