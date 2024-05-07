class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.54",
      revision: "2ecbede194e59abade8d3be5d013d27de3e88390"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba06ac3fa3159eaec69232e1bd6f91cc2a6c238c6e184b48ab9219735c1f45ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba06ac3fa3159eaec69232e1bd6f91cc2a6c238c6e184b48ab9219735c1f45ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba06ac3fa3159eaec69232e1bd6f91cc2a6c238c6e184b48ab9219735c1f45ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "810287d85860292c958ca951c84684d9519d3aa84437395d1321061e55f3a26b"
    sha256 cellar: :any_skip_relocation, ventura:        "810287d85860292c958ca951c84684d9519d3aa84437395d1321061e55f3a26b"
    sha256 cellar: :any_skip_relocation, monterey:       "810287d85860292c958ca951c84684d9519d3aa84437395d1321061e55f3a26b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93d78db45b7d2ec191c0e99a05bbe5a42d565691c49e4f4f126708511de51b5"
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