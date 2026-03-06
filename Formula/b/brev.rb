class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.317.tar.gz"
  sha256 "c1fa2cd924befad87d8942c0cef2a8c8b57283d4ca9518ec050d2df61322e5e6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c18c1bc5949f695ca0a9ebf102bc9817afa001484eec18ca2651a061527702a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c18c1bc5949f695ca0a9ebf102bc9817afa001484eec18ca2651a061527702a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c18c1bc5949f695ca0a9ebf102bc9817afa001484eec18ca2651a061527702a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "33b9e728fa40ce0ce85bad08244cdd23ac512fb0bb59958a94c929da933cdd02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0554c9edd96706393aaeeef34b7e8c21c02e8a76f20dad263770897b93ee846a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "915e9a2be2a068170e15ce4df765f001b2e5a10e36275e20a7c7277d11291ef8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end