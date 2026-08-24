class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.67",
      revision: "1124b642fc21a9e845d7455a1ad1f2ecf50639b5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b67b91680167ede81ff160542a9ab44ffc6b69cd46cbc28095d3edd9dfce2b4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53973d07558b720f1974125327e515f9fc82ccd930457255835b08673dfca0e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11b707ff7d0000be06986a0f475ac38fa670519bc1f1c4311ba1321fd60b234c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee2109075fa98dfa5a99bed58863a304725ce14e23671256d5008678963456bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57c2ad1a2595990ade7acb4bc2e3ceec56e5285bb3057d39638cb22008b26a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c28d96d1dac9c11b50f4147bab963b224534bba4db9c0d97eb03d846be00d03"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
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