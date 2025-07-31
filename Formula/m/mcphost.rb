class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://ghfast.top/https://github.com/mark3labs/mcphost/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "1c74c8e403ee572a323397032d30b4b3ec2332c92941764714f1bf221b78b022"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6614ebcaae2a668f92fc19e1a95e44d590bccc8bf1f05105503a1a868ef11d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6614ebcaae2a668f92fc19e1a95e44d590bccc8bf1f05105503a1a868ef11d54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6614ebcaae2a668f92fc19e1a95e44d590bccc8bf1f05105503a1a868ef11d54"
    sha256 cellar: :any_skip_relocation, sonoma:        "34691e86e28c5e23e9eb119afd9e1adebbeb4bd12b6a4ceb31b4c49a2df266df"
    sha256 cellar: :any_skip_relocation, ventura:       "34691e86e28c5e23e9eb119afd9e1adebbeb4bd12b6a4ceb31b4c49a2df266df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fc25e445d154bbf337cc0fb92c085d3e56232606a4198ca6ad0c1afcce474ce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end