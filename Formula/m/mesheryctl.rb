class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.15",
      revision: "4ff3b8dae732e401aec3be95f437329f1a8fc0a9"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6694dfe5a69c2d1fd48728f3064ad069b40b6be04c17adbf291f25d0dcf57682"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6694dfe5a69c2d1fd48728f3064ad069b40b6be04c17adbf291f25d0dcf57682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6694dfe5a69c2d1fd48728f3064ad069b40b6be04c17adbf291f25d0dcf57682"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6638e9c1b1a9b006d43a39ab6b623bbab23af72ae3eaf3ce330b1857b4a0fc3"
    sha256 cellar: :any_skip_relocation, ventura:        "a6638e9c1b1a9b006d43a39ab6b623bbab23af72ae3eaf3ce330b1857b4a0fc3"
    sha256 cellar: :any_skip_relocation, monterey:       "a6638e9c1b1a9b006d43a39ab6b623bbab23af72ae3eaf3ce330b1857b4a0fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b825d6de5bcb116558cd13eb6a9d019510f8f349f3cfe5d6f955020b03c788a"
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