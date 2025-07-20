class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.311.tar.gz"
  sha256 "a91053e82b0d096186571f9340d03caaef50110e8941ffb14acb7186e8e311e2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf6fc82c5ab1e2f3a309bbe7e2937280cdff11a38c0161c9fc1e4eb49164a147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6fc82c5ab1e2f3a309bbe7e2937280cdff11a38c0161c9fc1e4eb49164a147"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf6fc82c5ab1e2f3a309bbe7e2937280cdff11a38c0161c9fc1e4eb49164a147"
    sha256 cellar: :any_skip_relocation, sonoma:        "a311beee65bb0e2af1988513b30c586b6fcae4d432fc0a5fc1cc9a8f0b9cf323"
    sha256 cellar: :any_skip_relocation, ventura:       "a311beee65bb0e2af1988513b30c586b6fcae4d432fc0a5fc1cc9a8f0b9cf323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b689e354e31907f6b31634c212a10daaefae44269a38e2abfec4c069d68cae8c"
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