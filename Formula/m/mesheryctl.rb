class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.114",
      revision: "366a434ec4403acb450f0c45de8e950d8fee4162"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6442ec98430468c20e30f6cc5230e5bfb624071ff0430d7ec9d8e3f492484643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6442ec98430468c20e30f6cc5230e5bfb624071ff0430d7ec9d8e3f492484643"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6442ec98430468c20e30f6cc5230e5bfb624071ff0430d7ec9d8e3f492484643"
    sha256 cellar: :any_skip_relocation, sonoma:        "522bf1dddc15b0957cd03f913ae66ee048b5419b37398ff6907e250848d37144"
    sha256 cellar: :any_skip_relocation, ventura:       "522bf1dddc15b0957cd03f913ae66ee048b5419b37398ff6907e250848d37144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b780ddf79341688e83e77a7fce76f93471af1a3938886742f21f21f128771cd6"
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