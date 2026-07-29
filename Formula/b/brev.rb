class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.332.tar.gz"
  sha256 "840038544c6e34b2d01231dfa3b9d253eb80233a0bca15f27c1eb60724f2ca23"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "760342844dc2080f8a04d506c5ec3617423d2c6e57096e2bdd5509096f9e1a33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "760342844dc2080f8a04d506c5ec3617423d2c6e57096e2bdd5509096f9e1a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "760342844dc2080f8a04d506c5ec3617423d2c6e57096e2bdd5509096f9e1a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc26fa3a5d03d101659cf3bfe1899d8a59dea8398d991427c3509c4b92900ec6"
    sha256 cellar: :any,                 arm64_linux:   "365806aece2696f5d2609acdaf211afad8741e340272ca290bab70f137524caa"
    sha256 cellar: :any,                 x86_64_linux:  "d0427159d4d4328b453804e37f1f01d290c9055f42f25dfd5d493aa22700c879"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end