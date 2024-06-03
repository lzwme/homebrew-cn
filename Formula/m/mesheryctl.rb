class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.69",
      revision: "c3e713c908e34935fea7cb843c76c8de7b2cd27c"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1631858ea342f89d0b01ba1a9d7f5c92f7ea5a5464b47873b0ba67bc730cd937"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1631858ea342f89d0b01ba1a9d7f5c92f7ea5a5464b47873b0ba67bc730cd937"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1631858ea342f89d0b01ba1a9d7f5c92f7ea5a5464b47873b0ba67bc730cd937"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c5d1f04bec813ae3bd754d4d8704b873a0a17a9699fa266de2970b386cec828"
    sha256 cellar: :any_skip_relocation, ventura:        "6c5d1f04bec813ae3bd754d4d8704b873a0a17a9699fa266de2970b386cec828"
    sha256 cellar: :any_skip_relocation, monterey:       "6c5d1f04bec813ae3bd754d4d8704b873a0a17a9699fa266de2970b386cec828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d29b95c963fc3960734c0713d1ddaf2d3ada2be21926734a24535a423be3fdc"
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