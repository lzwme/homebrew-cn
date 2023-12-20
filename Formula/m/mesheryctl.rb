class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.3",
      revision: "2c9abfd2bd997bbad3cf18b48cae1b1c5a0d9961"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df8a231322e41324038a0e9c383066d2e38f2e853559e5deffc5d6ff71515d09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df8a231322e41324038a0e9c383066d2e38f2e853559e5deffc5d6ff71515d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df8a231322e41324038a0e9c383066d2e38f2e853559e5deffc5d6ff71515d09"
    sha256 cellar: :any_skip_relocation, sonoma:         "557c499a3638a6aefbe2230c4726106b188b8e0380d54622968d939ab44c9a89"
    sha256 cellar: :any_skip_relocation, ventura:        "557c499a3638a6aefbe2230c4726106b188b8e0380d54622968d939ab44c9a89"
    sha256 cellar: :any_skip_relocation, monterey:       "557c499a3638a6aefbe2230c4726106b188b8e0380d54622968d939ab44c9a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c90cbb562d95ea12f4a3c9f68d1d73e948a97eb77301fb863f7da88caa11b33"
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