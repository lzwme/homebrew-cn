class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.89",
      revision: "0e7f87a2cdd92846c38b4172b2a8c6e8570ddcfc"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "377fe0cc26b8391591bec7f1ced46f3486ba524b3451be9690d7a89f94a67056"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377fe0cc26b8391591bec7f1ced46f3486ba524b3451be9690d7a89f94a67056"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "377fe0cc26b8391591bec7f1ced46f3486ba524b3451be9690d7a89f94a67056"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c292a7bf4f454d7e850b3089c322bf46556f0a6c3405ede74ab206eca0ae33d"
    sha256 cellar: :any_skip_relocation, ventura:       "9c292a7bf4f454d7e850b3089c322bf46556f0a6c3405ede74ab206eca0ae33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3bbc03c5a541956eb957d31d85708c1580f839b4c508ae25b407005c29361bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8835c29895382efd88b95af808e02b410db0b5ade2fef42935fd81bfb3ce8a6e"
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