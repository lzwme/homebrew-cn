class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://ghfast.top/https://github.com/arimxyer/models/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "d4c78bb34bd04389122ba1bc4a3b29c2d803a47c7224616e0f850182189f3921"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27135b33e03d3ccedd8f3dce355fb376583a8091d6f1e4c0b45322bda829b91e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d36da836bfcc4df244656dac479ec668e71c139fcc14c15985ef2dc4397a761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c34848587f333d8ef19d9eaeba0a37544791c05ffda1f4e9081fc8a81bfa08"
    sha256 cellar: :any_skip_relocation, sonoma:        "27c0be1d3f9450cc23beefe381b613f4af8814a10f2ce6b4086a8f3032eb651d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "463649619857e6fda1f520f592f134b93c2a09e42ecd7771bc5d495620a283f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc8ce01919baf34ad2a16d1171408f2cd803fe7c756534c1f0e4b7ff05970b96"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end