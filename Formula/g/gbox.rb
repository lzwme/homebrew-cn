class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.19/gbox-v0.1.19.tar.gz"
  sha256 "9d67f857fcb1b45f677e7a366567490f9eea607893a7f4b376d3a3930e75fee6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad5b229866fb3462c473372171d5ba245627d0ac1cc9e7ce0c0d2cc68c0efd22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c996227a189a7dbfa236f3b0c25c456297256a5750b6a760f9d56fb06b680a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de370ba4d111b2bc71a5413c272f9d3516c4760ab04874d1bfad72c5ff4d345b"
    sha256 cellar: :any_skip_relocation, sonoma:        "476361843e6efb1e8a18a7bdd47bb39805c18e1b620edb037315e45009b245a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57fa30f1f9d74764fef9da5a19ddfa1c5c5f64f1dc2e1d45df21f9dc21617a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7934b7d558af346e82bc6e3b0531eaeb7f0dfeb478a7a3a364786345d9f8d3ba"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "frpc"
  depends_on "yq"

  uses_from_macos "jq", since: :sequoia

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", shell_parameter_format: :cobra)
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