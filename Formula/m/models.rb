class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://reyamira.github.io/models/"
  url "https://ghfast.top/https://github.com/reyamira/models/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "f71376b084b690a292ba375985ae13326c2072400fcef4f1a4b4a27315219597"
  license "MIT"
  head "https://github.com/reyamira/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a146c6b1d67fb80f6051a84f68e10e50cc2cb546f86158bfef555b6bd4418a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "246f574187830975662e217b186e3568d1322f4973661316610239557ba1bd1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d592840d1986605510891b5c8c27187a797077b3f413abe3865313b541f6fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "fef398546c2fff56aa03ad1ecab775dab7c64646fa822480fa7dce86e195d9ef"
    sha256 cellar: :any,                 arm64_linux:   "5030a40464bce4a3d01aaacd5c8d44039a63a0a9132854ba9f2b5849fee84133"
    sha256 cellar: :any,                 x86_64_linux:  "e7ae715e11da5482fe47d13a4cefb9227980c8fb460b84c452b1369afc843c77"
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