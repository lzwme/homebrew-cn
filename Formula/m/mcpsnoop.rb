class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://ghfast.top/https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "c68b915bb0cfc248cd72d04f55898f34cd0904076338074389e6422d3142de95"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7899b18f4ef246a5287b1c83f52f5ec222095e7c41994c2334d34cb6f6484e46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7899b18f4ef246a5287b1c83f52f5ec222095e7c41994c2334d34cb6f6484e46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7899b18f4ef246a5287b1c83f52f5ec222095e7c41994c2334d34cb6f6484e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a35bc1ff5f434679f88d9aa3996a556a2d11477c1986bd6a3897aade3ebb24ef"
    sha256 cellar: :any,                 x86_64_linux:      "1c29cd0a153054324d22b279cf6e24a0dd7c49ad0e88406a539e385d1a42866f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/mcpsnoop"
    generate_completions_from_executable(bin/"mcpsnoop", "completion")
  end

  test do
    ENV["MCPSNOOP_HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/mcpsnoop version")

    # Wrap a trivial "server" so the shim writes a real session, then check it.
    system bin/"mcpsnoop", "--label", "brewtest", "--", "true"
    assert_match "brewtest", shell_output("#{bin}/mcpsnoop export -T text")
  end
end