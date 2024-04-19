class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.48",
      revision: "4365cdf5d2b71e27475ce17a401339c06e3699c8"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d417aa6e47b4a7eb0ef43a45244453a32adb4b47ce27e6fe1fe9ac8bb5b6128d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d417aa6e47b4a7eb0ef43a45244453a32adb4b47ce27e6fe1fe9ac8bb5b6128d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d417aa6e47b4a7eb0ef43a45244453a32adb4b47ce27e6fe1fe9ac8bb5b6128d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf52a5b42a73d170f568db31afa59fd0e92f8e5ced5fb80f0cd643461292145f"
    sha256 cellar: :any_skip_relocation, ventura:        "bf52a5b42a73d170f568db31afa59fd0e92f8e5ced5fb80f0cd643461292145f"
    sha256 cellar: :any_skip_relocation, monterey:       "bf52a5b42a73d170f568db31afa59fd0e92f8e5ced5fb80f0cd643461292145f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d28a068731c10231835b0172818d4777a6e85d7a13dfde4bb84ee0ba8fe39bc"
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