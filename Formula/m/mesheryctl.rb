class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.17",
      revision: "9a8189e32bdf384e628eb040437830f637e11b64"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fb4c419e89b9281baaad92a42ab2bc90a6ecb0b18fa74d29871f57f5a047af5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6604d48247faf42cb25d59da7ec7aaa16ae2376e0edd55398c17aedc85c66504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9780412ce2abd37f0a268db3e82535b6ae4ac2492e71ed6b1b8088b11dd39ee6"
    sha256 cellar: :any_skip_relocation, sonoma:        "87ed1d89590a644ceb6fdf95178071a2054e2f1d911476a7b3c185f78d7aa6ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb90645ec833532d200b1477841309b8f53ea4f55bd0f6f1b14d5af51b3a5567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce7735547d024597dc6f5d3f7826bd75061fa4cb8947aec70e8cff5d5746c23"
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