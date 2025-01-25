class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.23",
      revision: "ec7a3660e616eb66fc5a0374b891343dae13c56d"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc98fb93137440ec87080a19fdcaf1c28ea58423e966fc289cba589e8c920c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc98fb93137440ec87080a19fdcaf1c28ea58423e966fc289cba589e8c920c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edc98fb93137440ec87080a19fdcaf1c28ea58423e966fc289cba589e8c920c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0007f1954c437ea5eb3f1ab41dd9b6e95d4e866946ef63531c63b26389c47683"
    sha256 cellar: :any_skip_relocation, ventura:       "0007f1954c437ea5eb3f1ab41dd9b6e95d4e866946ef63531c63b26389c47683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9b5843a7518839e24fe2b3f3fabfd46c7c4bb839817b78a10e44d1c4752090"
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