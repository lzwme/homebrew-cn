class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.169",
      revision: "cddf59622579bfdfec163399ccbfce47552e951e"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef627e6dfd1fa396997ae3d4fe628c00c0438ae4574be55da1d6971796bc1744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef627e6dfd1fa396997ae3d4fe628c00c0438ae4574be55da1d6971796bc1744"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef627e6dfd1fa396997ae3d4fe628c00c0438ae4574be55da1d6971796bc1744"
    sha256 cellar: :any_skip_relocation, sonoma:        "894c85f9db6d1db7fc983abbe9f3ede7cfeee92aaeac21ab3a4a43e49d289379"
    sha256 cellar: :any_skip_relocation, ventura:       "894c85f9db6d1db7fc983abbe9f3ede7cfeee92aaeac21ab3a4a43e49d289379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fd9186226058b404ed6f18e1a4fa4b11cb8284411ebc05c2bd218b42048db43"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end