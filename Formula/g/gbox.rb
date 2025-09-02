class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.11/gbox-v0.1.11.tar.gz"
  sha256 "d2c74d1376460fe22318fbed0b53f3b2dfcdb405e64a25f5d87de2e90cb869dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caafcb49ec793dd5a5f83e8600fbf19bd50d3a15d8560faa8838f760112fee6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd6e8bb9924806aeef839ad773f93d037ff081fd1745d2ba912f8b081f18c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17bde24eb520bab6d13d991848467e1001c5068370266a038d5a7de9a161c87d"
    sha256 cellar: :any_skip_relocation, sonoma:        "28baf54eddba7f34a75c05a3160aca782a993f48776612082ba59bd4cddc7dbe"
    sha256 cellar: :any_skip_relocation, ventura:       "9f01ad2bfa4e1a765a083fd791e87ac53a6f6940a1c125ad6a001574404f5377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19408263260f7741f3fa70b9b3c7cabba391b245ebd081617f56d6306e9a0785"
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