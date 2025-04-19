class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.58",
      revision: "293b7ca4d2027f7ed3e7b253d3e1a9d9715a240b"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84eadf0e02afda53d27ea986ea61029aaa05eda8d01f5d25221907ebfc7af8f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84eadf0e02afda53d27ea986ea61029aaa05eda8d01f5d25221907ebfc7af8f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84eadf0e02afda53d27ea986ea61029aaa05eda8d01f5d25221907ebfc7af8f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd8c256ac0a99f15ce717c023997b8511d0293cbaba03e1666f62549b355fb1a"
    sha256 cellar: :any_skip_relocation, ventura:       "bd8c256ac0a99f15ce717c023997b8511d0293cbaba03e1666f62549b355fb1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d409d1b6151afcb32d93563b039ffb160a6c9c64e4f0912765d81835b9b9f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b6b79217f941ed06e97bdbeac54a8978015a9f6778e0253e3c9f5351daaf4b"
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