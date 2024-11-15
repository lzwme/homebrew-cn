class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.151",
      revision: "6681ebeee6fca50769c5542a8adf13538bd6dd5e"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f035333164654ac6c8b5a22ecb373068c35daea014fa5b6245ef91297189b941"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f035333164654ac6c8b5a22ecb373068c35daea014fa5b6245ef91297189b941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f035333164654ac6c8b5a22ecb373068c35daea014fa5b6245ef91297189b941"
    sha256 cellar: :any_skip_relocation, sonoma:        "5803cb8b23f5cb8bdd5f359ce8c644b24212ad38ab17c8af53dc7fb046a40b45"
    sha256 cellar: :any_skip_relocation, ventura:       "5803cb8b23f5cb8bdd5f359ce8c644b24212ad38ab17c8af53dc7fb046a40b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee9fe86d557f25560d193858b91f37aaeb13afb4d74a11d201862996b8ed423"
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