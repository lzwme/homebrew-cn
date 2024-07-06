class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.79",
      revision: "71ee6ee03cee4fd91841e6e1e78c427e01eca2e3"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6b5de707b41eefdc7d5d548cd88759e5a62956eacba66f7bc8261e5df1213d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6b5de707b41eefdc7d5d548cd88759e5a62956eacba66f7bc8261e5df1213d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6b5de707b41eefdc7d5d548cd88759e5a62956eacba66f7bc8261e5df1213d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c938a0425e09a89c379f1b9e5036c9b4b693d0bc6f6b16c1f52de43e666118d"
    sha256 cellar: :any_skip_relocation, ventura:        "6c938a0425e09a89c379f1b9e5036c9b4b693d0bc6f6b16c1f52de43e666118d"
    sha256 cellar: :any_skip_relocation, monterey:       "6c938a0425e09a89c379f1b9e5036c9b4b693d0bc6f6b16c1f52de43e666118d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d08aa11486a456f7e3b7eb5aa3f2a57ce7a29a82ab8429b28e63e7e8c52728"
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