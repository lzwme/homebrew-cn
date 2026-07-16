class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.330.tar.gz"
  sha256 "f145bd41b263ae742c2014f79e86e19581eccd6327914e843e756744bfc2d124"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae58d9f8decb3e866d2eb3fa939cf21f7616b79890ef4155ca744bc39cca5506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae58d9f8decb3e866d2eb3fa939cf21f7616b79890ef4155ca744bc39cca5506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae58d9f8decb3e866d2eb3fa939cf21f7616b79890ef4155ca744bc39cca5506"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0323407fc459b0a6d92223c96514b6d86d276cd1774a9b1f707880937552d32"
    sha256 cellar: :any,                 arm64_linux:   "eedcb7412565d054c0d291536d0d06d74b30e3e2cb9b383213c30bcf5de5eeea"
    sha256 cellar: :any,                 x86_64_linux:  "41431e01e1bda30a6eca98574d50b49e5912731dbc6408a10576dc4c915abf79"
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