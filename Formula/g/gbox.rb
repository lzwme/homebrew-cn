class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.17/gbox-v0.1.17.tar.gz"
  sha256 "48355c7859f009a16147af23a8646f77399a74bab3a36fb591281160a8c576a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "939674773bc37b41d44008a107df9ff169a3a79752ff150adb07db3db6e15fc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6964bb89469ea64e4057cfdadd7cec7f82f2c3b391272d7a4432c6c4e8d8c61f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00b45ac530f569ee2b22598e81c0101e3386e85491f3b19b51939f555af6415"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf504b38774260c028533277882122c114723419aa9da2133adf03a46cd32011"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8774c8778fa4eb075f1505ae87690a107d50aeb7e364eeecf520a07deeb72eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c622a304df0b1beb7de3131380e87c05cca82cb3e51cb74930dbf39fae5576e"
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