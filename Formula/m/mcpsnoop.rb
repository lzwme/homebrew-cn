class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://ghfast.top/https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "81803b0c5ea1f54dd03a9da9578d7f8aecf05f763deb922a58ea2fa46f34daea"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e72eaa37abc6a68e278e04f74790b29d741a11193f68effe471498fe0532138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e72eaa37abc6a68e278e04f74790b29d741a11193f68effe471498fe0532138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e72eaa37abc6a68e278e04f74790b29d741a11193f68effe471498fe0532138"
    sha256 cellar: :any_skip_relocation, sonoma:        "a28885e1e3d39ba74c6640d6958b5d6cf4006972900ca5f375be5652c97977a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72efc4afca657c1cd93763a09799a8e0ebf532bb42f605facc39fde98ad9fb08"
    sha256 cellar: :any,                 x86_64_linux:  "494c6e6a1a884666a54b9a286afd2a846f7a83a3fe89739a7c1c743b6825efa4"
  end

  depends_on "go" => :build

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