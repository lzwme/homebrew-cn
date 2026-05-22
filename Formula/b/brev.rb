class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.325.tar.gz"
  sha256 "e3f3bdb29b33c9a3233be4e0be2305f4008f94c257a78689f76900d6453a04cf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef3dddceaaa6a6f64d8060adcd633dd03603254d08a4dae3af2b009da9ed2572"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef3dddceaaa6a6f64d8060adcd633dd03603254d08a4dae3af2b009da9ed2572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef3dddceaaa6a6f64d8060adcd633dd03603254d08a4dae3af2b009da9ed2572"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe928a270455c3e59675abcdbc25d0c79f34b90adc0bcb207a3cb460b8c421e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50ab690b3ef78ec34a921664d165ab537281889555293c3e99cdc7788938f9e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a8d96cc449619cd1f64eb36f75d49f9f408374110b88b41e17c3af8a9f614a7"
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