class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://ghfast.top/https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "db65c3617838cd9ff1b3b99982a0dc7b10320a469c3f53467679aff9f2f0175d"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3dae289bd4f49bd8094db3ac2286ded7b1bd0b7138845034e7041902faf9e647"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3dae289bd4f49bd8094db3ac2286ded7b1bd0b7138845034e7041902faf9e647"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3dae289bd4f49bd8094db3ac2286ded7b1bd0b7138845034e7041902faf9e647"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40fa0ca367e3b4bb5a3cb812305c4140964c050305c24aee332c73ff76fca0d1"
    sha256 cellar: :any,                 x86_64_linux:      "6324d82dba1087959fd7b16b6e91438704ba07c457d71ad5aa1700c67c8491e4"
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