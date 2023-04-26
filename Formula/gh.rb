class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://ghproxy.com/https://github.com/cli/cli/archive/v2.28.0.tar.gz"
  sha256 "cf3c0fb7f601d717d8b5177707a197c49fd426f5dc3c9aa52a932e96ba7166af"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "122e27e8e43ed8901b573a62942fa2a5751fc115be9a18221d671939fb3ff976"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "122e27e8e43ed8901b573a62942fa2a5751fc115be9a18221d671939fb3ff976"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "122e27e8e43ed8901b573a62942fa2a5751fc115be9a18221d671939fb3ff976"
    sha256 cellar: :any_skip_relocation, ventura:        "ae149964ca6ced037e00d84fdcff900d031e5ff8eb84aabaec49598d8866f95a"
    sha256 cellar: :any_skip_relocation, monterey:       "ae149964ca6ced037e00d84fdcff900d031e5ff8eb84aabaec49598d8866f95a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae149964ca6ced037e00d84fdcff900d031e5ff8eb84aabaec49598d8866f95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "480fab8be1a4dd65c449ed8727aa82d220cca250e9c51d23e64b89b28296ee21"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end