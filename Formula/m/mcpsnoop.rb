class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://ghfast.top/https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "a23ce56f8895a485cb056ea7d1e697be0ef9d1ef224db1d2789f0e9d5de8ff32"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c0f4586459c7320029f3e7811533cac7810a5261f5d30cb9a78e18e1a36b74c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c0f4586459c7320029f3e7811533cac7810a5261f5d30cb9a78e18e1a36b74c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c0f4586459c7320029f3e7811533cac7810a5261f5d30cb9a78e18e1a36b74c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "353cf3e2e1ace43c29af3852dcde8664745f1370a2479cfebea891377650ef38"
    sha256 cellar: :any,                 x86_64_linux:      "86aa95881a8e73366250286ef1d9d985f7a5bdf1059e0ec9f32f186bc3d9b9ed"
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