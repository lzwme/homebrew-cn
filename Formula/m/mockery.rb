class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "ae74014ab6225f36149b7b27f982c4e30d7724a4a1ddcff5c8aab38eaf9a4fa7"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dabd50b85b8aec957b4d54b20998cf14a10e74b79e74dfc0acd27fce6c089e4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b03699e8f582b066488a546f76f6517df7a0dc68cbdefdbc1d68dead3d693b18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71f52c219d3099b8fd38833ea0718408fe5f9e7a0dce665f4eb2fe22c21e1f3c"
    sha256 cellar: :any_skip_relocation, ventura:        "f8bb31e7992c4b7478237062e396fde835ede2f41cc77d3ea7e5803130e19da6"
    sha256 cellar: :any_skip_relocation, monterey:       "4c3e20f6eef6d1401699f5f754a54305b11d54b52bd2ef0604023d54649ed971"
    sha256 cellar: :any_skip_relocation, big_sur:        "76345ebd907b6f637f55adb67059cd19698ae66a301d416f4b28c04491c88434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad0125ffa41a7d8a352fc479d4b1f38ddd6e60b872e097c1f75f43f006fd2fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end