class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.319.tar.gz"
  sha256 "50c8d176aca85ee4dcd33e29133040a5c4b58404351b0d6a65e4da3cc91cb46e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c084b7e2d0aa8d2638d35805ce65e2dffa32851d1b8453061eae90a971c342a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c084b7e2d0aa8d2638d35805ce65e2dffa32851d1b8453061eae90a971c342a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c084b7e2d0aa8d2638d35805ce65e2dffa32851d1b8453061eae90a971c342a"
    sha256 cellar: :any_skip_relocation, sonoma:        "557586466f23b19a5644c6e3196fcd5ddc7b07f2a53af79f2165cd9e756029e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54008ff4a3b7fd80036ce88b6edc933332dba00a968277159a5eaa8f5340e2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c36e8b0c9ab59af721e68031f76b8ec63f612c29545efda5b2c030aed7077a"
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