class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.318.tar.gz"
  sha256 "da3c6673da7d84df545c28efa5dee728e6c78769f568a040daefa67e3dcda6ed"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "484ff2e663018b1b266b9650f9210d0f6359e9d79b1893aef1e86a5d00e4726a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484ff2e663018b1b266b9650f9210d0f6359e9d79b1893aef1e86a5d00e4726a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "484ff2e663018b1b266b9650f9210d0f6359e9d79b1893aef1e86a5d00e4726a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2920e839a2e6a9913140d9214984116b1e257dd2b37c7412a67cef26ecd80f5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c13f4312374e142d2a59e7705ea12c2bcc8f266b4acfe767f65f9b07d1997ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d40d02f520c352e198114df816a2f567891d94b74b1bc74a3466a085c1531a"
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