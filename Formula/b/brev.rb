class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.321.tar.gz"
  sha256 "c4f33bd386f240962f3eeab90023f184514733d4891e02c905d4e4d5a2e7ffc5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c3e8bf143e806c6529558ca51cd7b1f3dbb5c58ec10cdc3842f05f6a94b46f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c3e8bf143e806c6529558ca51cd7b1f3dbb5c58ec10cdc3842f05f6a94b46f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c3e8bf143e806c6529558ca51cd7b1f3dbb5c58ec10cdc3842f05f6a94b46f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a9ee4e263970663668941e8aacc7f41fc0777f0fb46399f92618bdf04c6bddb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7fc64c0f04a06776fcf90d62f3b4641d2cdf956e0391fef90473510bdee147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a358837eb3ba88d80b285ec66177080d574f49bdf9336413eed02ba6fbaef4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end