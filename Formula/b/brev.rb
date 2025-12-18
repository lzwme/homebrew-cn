class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.315.tar.gz"
  sha256 "5bb2e40d4dd80d368c2c0dcc1b2520eeccc530555381b578ed73270ddc4ec180"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e61bcca8c3dc2ff9e0f98f2ef29fdacf108bf2b15407ddb0da30eea0d8f1a295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e61bcca8c3dc2ff9e0f98f2ef29fdacf108bf2b15407ddb0da30eea0d8f1a295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e61bcca8c3dc2ff9e0f98f2ef29fdacf108bf2b15407ddb0da30eea0d8f1a295"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e9d108663bcd696061bcf92e0bef3f27df240be6189dac0c1bf80f8c1ec3b24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8bda584583e744917540bb0af8190a37e4f401627629728d61ce9c913e9bc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9893c428f6ba24ac3668c7f88dff7655a2e9e3279121ff60cd57d7b67f855e45"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end