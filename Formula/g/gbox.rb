class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.15/gbox-v0.1.15.tar.gz"
  sha256 "782bdcc377fa220944bf185f9ad2860c91539b84b6f15f2390305f186198c484"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "282f9c8f0e3f9cb39a05f31a505c37a72c9b768e958f9aca89e19239053c8e67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd056ad9cfb448d7c3a03d246206a6143bfc25f4e37ba22dc9a99778a04c685"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2de1bd4b5b2a5d23aba7a54d4decafab52cc92256365ea0f03c67919378c13d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd85b32acf5b40a0dbf8e6a3f0b9fbfebb9f673a28e9b9adc95eae5d32aec1c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d22c454544bf8bbe524f3a5c8568c7116432b90330c58b84f49bac904d9e263f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a8be1c44fc75fa84807425d15270115df56bed75a4c5c9011623722483d238"
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