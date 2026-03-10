class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.213",
      revision: "729e80486909c3facfd08f972946f35258277b1b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "720fef80dda34b0cd4a47e504ffc3e5e6bab70de066aca12c27b77dcb6241518"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f914bc74f93bd346d2e21b54ced7539ced960e33051713677472f23402cd0e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "618a5de708a45ab0bcad7f88ce56d8b46671ca95a96ca0ec7d8e6e15c8fbf7a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "df43ae20779ebc53124e01b9d381333873fb4b711a31af4dde05882b5c0bde52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6509fb6474657b6d0cd9c0fcdbe9dbbe225d5e7e10ae81579fa1c010776bf916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2108b325361bff4f447939d5f8ddb3247f91325500b077d5abb94e509205955c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end