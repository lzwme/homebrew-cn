class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.10",
      revision: "352e129223ef90358a1ca89f3f99fbfb06c54a62"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "819426009f0986431d0575d5a3ed38dd41c0d347cfe0f5d7342fadb490a34a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "819426009f0986431d0575d5a3ed38dd41c0d347cfe0f5d7342fadb490a34a32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "819426009f0986431d0575d5a3ed38dd41c0d347cfe0f5d7342fadb490a34a32"
    sha256 cellar: :any_skip_relocation, sonoma:         "343006f3551b8fe1cccbf5a067424dbe139c48bf3b1b41fac1f1d8cc304dc371"
    sha256 cellar: :any_skip_relocation, ventura:        "343006f3551b8fe1cccbf5a067424dbe139c48bf3b1b41fac1f1d8cc304dc371"
    sha256 cellar: :any_skip_relocation, monterey:       "343006f3551b8fe1cccbf5a067424dbe139c48bf3b1b41fac1f1d8cc304dc371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3cee88c8948f95ccaa836412df984680571524bbf07c97ae5294253b5cd5ac7"
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