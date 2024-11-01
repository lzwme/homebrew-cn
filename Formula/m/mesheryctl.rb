class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.131",
      revision: "3019a439bae3f76c160fec6fcf48675bea081257"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4286b1a8ab6af222bd2f49867effb6fcbc1af75185aab924f906c3f15ffe3bf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4286b1a8ab6af222bd2f49867effb6fcbc1af75185aab924f906c3f15ffe3bf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4286b1a8ab6af222bd2f49867effb6fcbc1af75185aab924f906c3f15ffe3bf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9893c5a946167f8bd3e8a8a126cc9300b78ced90beeb60b075a995c6afc3e94"
    sha256 cellar: :any_skip_relocation, ventura:       "a9893c5a946167f8bd3e8a8a126cc9300b78ced90beeb60b075a995c6afc3e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3858b2fa94e1d56cb18f0f55a939e81fb91f0bef858320a8dab3d0182a39b2a"
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