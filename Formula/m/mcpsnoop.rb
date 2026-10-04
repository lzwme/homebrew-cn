class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://ghfast.top/https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "3f82a4f73567093841a3453440d56e3473b113d3ce3ff3493fdc6522f235bc3d"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d086cf5e2f1c2bb7b2b6ba51af47f9961808d4dbbfe3ba8fab2814dc22c3adc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d086cf5e2f1c2bb7b2b6ba51af47f9961808d4dbbfe3ba8fab2814dc22c3adc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d086cf5e2f1c2bb7b2b6ba51af47f9961808d4dbbfe3ba8fab2814dc22c3adc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "445d6dc18e78ff8928f31299e93a23a1b333647b209535d5f1dbd7587aa19234"
    sha256 cellar: :any,                 x86_64_linux:      "d834b5d8e60108c0e6027b1417fd719c51f9b00c3fa4147340deb621d138a4ef"
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