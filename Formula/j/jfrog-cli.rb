class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.78.3.tar.gz"
  sha256 "c16c0abbbfc5e477ce898d5e40dcb756f5a75793d02b03ee32a632844a9e2016"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a20e587ce28f44f86ae2105d5db61bd27a6eea2ed825da39c60d931d8f49555e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a20e587ce28f44f86ae2105d5db61bd27a6eea2ed825da39c60d931d8f49555e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a20e587ce28f44f86ae2105d5db61bd27a6eea2ed825da39c60d931d8f49555e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3b7a2f00cd35bd2575a1ad9eda0c2ac5e3b52800b5ce181fad98f18e45958df"
    sha256 cellar: :any_skip_relocation, ventura:       "c96487dbd70491053906f57ec685574bdda04d345883336350adceac0db0127b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0235423f51dbbcf0997173b7351d743b510cddb0d2f441525cae3705930b3d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end