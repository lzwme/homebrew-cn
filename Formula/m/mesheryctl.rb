class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.103",
      revision: "2e43616d7b3b6f8916867bb52e1d57b913b60efd"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2445bcc485042450118c23132eb8fba8f4c3df6225092c3ff27d11229525b3f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2445bcc485042450118c23132eb8fba8f4c3df6225092c3ff27d11229525b3f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2445bcc485042450118c23132eb8fba8f4c3df6225092c3ff27d11229525b3f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "656a81982abaec2805fc778356cff31e5dae43774a12aea095a05c728ea71a97"
    sha256 cellar: :any_skip_relocation, ventura:       "656a81982abaec2805fc778356cff31e5dae43774a12aea095a05c728ea71a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5728c357675e6f281ab91b0dae3512eb01b813b04627e9dff28327672f3560f7"
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