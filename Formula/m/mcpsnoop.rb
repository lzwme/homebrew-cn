class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://ghfast.top/https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "c05e98513cbb4865e334f8986c74a39adfa4a390a43260b2940f50c877fb06d6"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d89320918fd559612f9168ef237682920eb8fc77d6ba0eed48c59b5e1c27f310"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d89320918fd559612f9168ef237682920eb8fc77d6ba0eed48c59b5e1c27f310"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d89320918fd559612f9168ef237682920eb8fc77d6ba0eed48c59b5e1c27f310"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cdecaf82797bd65a946f41f6379a7c3de19e790880ecfb9fe4a978a4979c80ae"
    sha256 cellar: :any,                 x86_64_linux:      "abe925291afab38aad6460c4dbef171ebc14b1035d9e74319d977918bf496c38"
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