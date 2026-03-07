class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "9e92d0c0844ca4b07e838b0696b897958bf489b8d4bbd4e22c1cd2418f3c53c0"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e975cfea88030055555c3e29a6972428cf6e8ef02a84f3d838b1e6178f1d73f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46a4b92e7b257de5752cdc9acb8019497d3147e581df15c451400bb68d8fe22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9da0a5e39c127dc124ab56b7bf6ee54c6e21628479900efbb0c32748d591b10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc54859ef2321772ef4da52e2590e62e98b5d4c81330bfb5c7ea3dbd426bde1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89902d7ab48bb5c5763c194d65478f5d7394981ea531da63239cea5524771007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "648e3549f94ef5c0496fc9b9cf987667b1a8b6fab81501e6c5d57b8bd01ed500"
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