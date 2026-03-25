class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.0",
      revision: "6161f0b1dada5a4ca9b88da25b553cb5e653436f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87635a42fea9107d8d3470791b143dc37d9582a0bb89260b65c6667d63cfe05b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e20645d1b8ecf0d3d24209e1c9e540842160de4b29c8ee834a0076ca880a8491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e213c69d2ced488e8ba1f31db2f64ada3340bd97f5e4dc0e79979ef1910da6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2222187a30a835d776d15500128af3047fc164af414a05cf78b2a83c61a08a4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e47e5fb2fc22514d7e93d3a1606ada2a4494513ce9d9fb5509acc8957173e705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42465b4b2561c6a41e3d1e7711fd0d392437daf789a770280ebf1ef19c893d87"
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