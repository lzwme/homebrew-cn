class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.17/gbox-v0.1.17.tar.gz"
  sha256 "48355c7859f009a16147af23a8646f77399a74bab3a36fb591281160a8c576a2"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f399daa6aae8a063190ac9a538d27602155807be54656de90f2fbb86925fc660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "479ed25fd38584e2210bb465ca4ca05e84a5b3d48929afd4d3894524d00d66a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf2ff6e59adeef83fda1b5eddd0c81913b2a59dfff192f5c86715b895ee02ba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "07359e14d74e1b687703087601323dc9d353d41f48db17c1e104b43342658887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df3fe03b62172d08ad7f3f26b6e4269af312077348633302b3ce4402c494545b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3293249ed91dd941e505dacb1aabfdf8ce90be3d9fea86790ccdc3b24c65970"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "frpc"
  depends_on "yq"

  uses_from_macos "jq", since: :sequoia

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