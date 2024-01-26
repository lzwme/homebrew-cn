class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.13",
      revision: "96bb0f665266b2ddc06b2cb9cc714acb02889ec5"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fe83681eef80da7025de9fe4bcaf0447d73e9adde0ec23b08c9b5b186826a0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fe83681eef80da7025de9fe4bcaf0447d73e9adde0ec23b08c9b5b186826a0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fe83681eef80da7025de9fe4bcaf0447d73e9adde0ec23b08c9b5b186826a0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9efa2eeba75b56d183ce43098daebf25257b00a870ae1f53640c70ec354d8e3f"
    sha256 cellar: :any_skip_relocation, ventura:        "9efa2eeba75b56d183ce43098daebf25257b00a870ae1f53640c70ec354d8e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "9efa2eeba75b56d183ce43098daebf25257b00a870ae1f53640c70ec354d8e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "158d33453c6cece6adee9f21ab9afa2485635776aa540a269371de4c55324c4f"
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