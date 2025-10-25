class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "21124273c16d81dc9d61065da93e865848de7be680802de150599681f96b8a7a"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c51a8ccd8c30e3ac86597152471f16724857b6078b9f8f93b43200ee7f80f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c51a8ccd8c30e3ac86597152471f16724857b6078b9f8f93b43200ee7f80f3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c51a8ccd8c30e3ac86597152471f16724857b6078b9f8f93b43200ee7f80f3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab42c0b1fb42e4dbed9fb2237391761c72a504e2b1bfca0a1d20f4373722b433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0ca250f05763e03d4d358390fcf4b3ab834158c92cff839fdf18038c8fdf9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e75bcea0b55553492f8260e733a8b9786460a23e3e92e088030798f1c20e712"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "io.github.YOUR_USERNAME/YOUR_REPO", (testpath/"server.json").read
  end
end