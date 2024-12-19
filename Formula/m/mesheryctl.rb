class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.171",
      revision: "ba303cc500a6ef557d4b86a155449d0994bdd484"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cadf912299db289fe71094fd9ae8febc04c6e281f8b1050e47c867e867737f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cadf912299db289fe71094fd9ae8febc04c6e281f8b1050e47c867e867737f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cadf912299db289fe71094fd9ae8febc04c6e281f8b1050e47c867e867737f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "755e18233afba2b9ffec9c9ce097911a373a02f47c9a83b9650af6ea51351e58"
    sha256 cellar: :any_skip_relocation, ventura:       "755e18233afba2b9ffec9c9ce097911a373a02f47c9a83b9650af6ea51351e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "009b6aa00a39124438d7231224b0dc33e73b42de2ed06616d150ff40b604c8dc"
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