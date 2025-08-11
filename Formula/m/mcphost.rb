class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://ghfast.top/https://github.com/mark3labs/mcphost/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "7071044ed4fc78f1373289ac7fa55c80d59f9dc7fab63700ba9d23201ace715a"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b3c6b6769033110fee549a364db3e86ac7305d7a6e4cdb9635fadfd2723795f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b3c6b6769033110fee549a364db3e86ac7305d7a6e4cdb9635fadfd2723795f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b3c6b6769033110fee549a364db3e86ac7305d7a6e4cdb9635fadfd2723795f"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e62fc1572ca153e17f3b08b556f858dae8587bcd64ffdb8a6ddfc6dc17dcef"
    sha256 cellar: :any_skip_relocation, ventura:       "51e62fc1572ca153e17f3b08b556f858dae8587bcd64ffdb8a6ddfc6dc17dcef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1bddd85ef20dfc81f90cc5955d4d0ddc0c2f81064270b06b7db98acb2bf4572"
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