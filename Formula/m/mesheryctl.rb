class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.77",
      revision: "b4f623bd45805568472a4260e782361fe1e6d81f"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8897b97553dc6092355d5d725a77b429322ccc2dc818aca5ac4d122cbd5ccc7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8897b97553dc6092355d5d725a77b429322ccc2dc818aca5ac4d122cbd5ccc7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8897b97553dc6092355d5d725a77b429322ccc2dc818aca5ac4d122cbd5ccc7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfc586a1a72e492aa53d3b60347b9f533db6f64ab7ece499ee4e5eef53b816e6"
    sha256 cellar: :any_skip_relocation, ventura:       "bfc586a1a72e492aa53d3b60347b9f533db6f64ab7ece499ee4e5eef53b816e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3be9086ca099289b2384e3f33c98957a6525b80ebda8533bb67304e2c52edcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b503fca9f69785b90550e426aa8d17777e8ae078e8322653de37b53cfcbb35d"
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