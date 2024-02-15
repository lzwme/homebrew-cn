class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.20",
      revision: "63a624f05989c7ff24de11ea5f9b2c3960041041"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bff8d8648b347b03910e508cae90a8c115fb279de35c4e5a9c3530e28de08ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bff8d8648b347b03910e508cae90a8c115fb279de35c4e5a9c3530e28de08ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bff8d8648b347b03910e508cae90a8c115fb279de35c4e5a9c3530e28de08ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2bf1c1ea5cd27b7d971ae5493b6760435c3344696fa4e37f8d60071c884628b"
    sha256 cellar: :any_skip_relocation, ventura:        "a2bf1c1ea5cd27b7d971ae5493b6760435c3344696fa4e37f8d60071c884628b"
    sha256 cellar: :any_skip_relocation, monterey:       "a2bf1c1ea5cd27b7d971ae5493b6760435c3344696fa4e37f8d60071c884628b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9da968731387ca102613d4b13eee426dd1aa4c104e4c443c27e2dfaaa2051f6"
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

    system "go", "build", *std_go_args(ldflags: ldflags), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end