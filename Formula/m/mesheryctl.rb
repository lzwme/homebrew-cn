class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.167",
      revision: "bc5e2a5f659e4a6c7b862fa2f12fab0442672d89"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d72fcd3af7f28aff6a6e7f39bd3b3880ae31c51e6c3add25362bf6235cebfeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d72fcd3af7f28aff6a6e7f39bd3b3880ae31c51e6c3add25362bf6235cebfeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d72fcd3af7f28aff6a6e7f39bd3b3880ae31c51e6c3add25362bf6235cebfeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "63e16f33cda69cc64b2840b25542031bd813b27c702e164e09b921c8077ccbfb"
    sha256 cellar: :any_skip_relocation, ventura:       "63e16f33cda69cc64b2840b25542031bd813b27c702e164e09b921c8077ccbfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7a6e46dc1d36e6b1b8e70f612202b79c3bc53d30f64245af868e0cccdbe0ab7"
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