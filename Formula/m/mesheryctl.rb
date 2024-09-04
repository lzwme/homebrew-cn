class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.92",
      revision: "b0b7c85873dda556dcc6badc36fd6507bd4ee640"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55ebc705370316a9e129f3bc22a5b58f8b053d4a1f40ae673696ab8b4550ddfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55ebc705370316a9e129f3bc22a5b58f8b053d4a1f40ae673696ab8b4550ddfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55ebc705370316a9e129f3bc22a5b58f8b053d4a1f40ae673696ab8b4550ddfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c67403c53138b9878d725354cacbe08d481ccc621d1471fa5eba23ba8bebc178"
    sha256 cellar: :any_skip_relocation, ventura:        "c67403c53138b9878d725354cacbe08d481ccc621d1471fa5eba23ba8bebc178"
    sha256 cellar: :any_skip_relocation, monterey:       "c67403c53138b9878d725354cacbe08d481ccc621d1471fa5eba23ba8bebc178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e437519597b8bdfba769a1767b0e3e49e9b8bdd8d0016fc93d6142feaa8cb3d0"
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