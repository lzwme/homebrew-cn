class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.328.tar.gz"
  sha256 "a9359475e22f86bcc38f5448dc37b45e02fef4c455f1cba58bcbfe27d515cc57"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9916486fc57e361735189b8918e5fe7091924ac8d641b74d2ce0ba037da59826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9916486fc57e361735189b8918e5fe7091924ac8d641b74d2ce0ba037da59826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9916486fc57e361735189b8918e5fe7091924ac8d641b74d2ce0ba037da59826"
    sha256 cellar: :any_skip_relocation, sonoma:        "09ca8bf37d6e0cbebe4137d9bdf65e00ea8547da189975d7ff0e0f04e5aad4eb"
    sha256 cellar: :any,                 arm64_linux:   "f55ec56282a8591aa3931c408dca010339b7044af170eb30d5303d2f221f4ffd"
    sha256 cellar: :any,                 x86_64_linux:  "064b11b8d277b245bf7c6590294ea67dd6d2e49a0127e2d5e7cbaf3964cb79ab"
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