class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.128",
      revision: "4cdb66e42809d21a2fc3a025a2a5c6b9adcb1cdf"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "525e537bcda026082d0ecadd20764b9f1bcf6980e72355cbada9a238f6e5c487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "525e537bcda026082d0ecadd20764b9f1bcf6980e72355cbada9a238f6e5c487"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "525e537bcda026082d0ecadd20764b9f1bcf6980e72355cbada9a238f6e5c487"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cb50322b94aa0d85fafd0f59c243cd3732c3c6122f3e6afdd19937b71cf3ca7"
    sha256 cellar: :any_skip_relocation, ventura:       "8cb50322b94aa0d85fafd0f59c243cd3732c3c6122f3e6afdd19937b71cf3ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4adad8990b7c4e1da521921871fdd854993f5f5e363c53d83f715a8d6cba6c69"
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