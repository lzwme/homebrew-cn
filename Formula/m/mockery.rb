class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.34.1.tar.gz"
  sha256 "ff059e0ff5d3c35625d07764caee3a8f967a9f3285dea0546c9624dfcbfba18b"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab8cff610bfc528101071ecf0119dae5d60642c85634720c818a8f18cd627a6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3bd3e8c77eee92bfeafd5c65e34d222fb6577aec1c41b516556caa14d768431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f14a8e69296ca18a6941f56e65b707d260ad4805585620685e5ce77f967f0cf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "91b1000b60301c6b0ba789e89ea0f10422fa7e5978dcb98780352ded4b0d9a23"
    sha256 cellar: :any_skip_relocation, ventura:        "50bf8bf9918e02593134a8f2ce0f34b187497c8f4d04a8dcdfcaf45244426963"
    sha256 cellar: :any_skip_relocation, monterey:       "258abaddae9f304be8d6fd17829aceae6e98cae0b643d905ef9d8e7c12287e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d4c245f86b89a3607e0e0fb369917dff550a1d0f95124eeed7d329dc2fa2816"
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