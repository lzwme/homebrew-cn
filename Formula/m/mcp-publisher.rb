class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "aeba4ff200d2f3385b5df3af6309869ed9c7d7ba9970b9c012a4f5cebd3c6541"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6118fb056506de46f4eecb9089eb98d25d6854a9a709d7cc80edd68981c0ed1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6118fb056506de46f4eecb9089eb98d25d6854a9a709d7cc80edd68981c0ed1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6118fb056506de46f4eecb9089eb98d25d6854a9a709d7cc80edd68981c0ed1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3577d93d67bc9398d74e3c831d60fb83bff1d544317986602312accce172815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14eba5618f70680a5662d08a800180d23074bff9ba24149de0ae79fdc7b7d980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "653fb71c1a67399b56f30da72ffc9736ad8187054a7776897f2c5003d9a5e085"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "com.example/mcp-publisher-test-", (testpath/"server.json").read
  end
end