class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.9/gbox-v0.1.9.tar.gz"
  sha256 "67c32b28c7a31076d9a5e0aaf4c387d2916463da85cd7c3aeb656109e8a603db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f767707fb6afaef341e6c92fd40129071d854bd50532cbdc8d77a40d51cfebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01fe07a868757cf16f1c892066ed34a5ab4aa77d702690acd67ba6f541209fdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab77664af873e8d185432e2cd3374ecae90a6900b16c6e7c8485d3587bb5f7d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34c20263b5e45f2421c3600d9a107f1c51633f497e9ac47ee1123bb351cdb49"
    sha256 cellar: :any_skip_relocation, ventura:       "b2d8e5bff3a3f10416dd6827a50169044d328f4bdc9d3ea08560e5aac528bd53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61cef6fa25b15abd9991488d0ff15bd77874c20b8f5c0a3642fc2118a804bab3"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "frpc"
  depends_on "yq"

  uses_from_macos "jq"

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", "completion")
  end

  test do
    # Test gbox version
    assert_match version.to_s, shell_output("#{bin}/gbox --version")

    # gbox validates the API key when adding a profile
    add_output = shell_output("#{bin}/gbox profile add -k xxx 2>&1", 1)
    assert_match "Error: failed to validate API key", add_output

    assert_match "mcpServers", shell_output("#{bin}/gbox mcp export")
  end
end