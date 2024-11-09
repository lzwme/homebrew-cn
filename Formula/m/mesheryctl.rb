class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.140",
      revision: "7b6af1fa2b1ff6d1c0491c432e228fb67eb73d29"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53db5648cbb454fda1f76d5dcceec7933ed9f6108bb64274502e071c1a149010"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53db5648cbb454fda1f76d5dcceec7933ed9f6108bb64274502e071c1a149010"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53db5648cbb454fda1f76d5dcceec7933ed9f6108bb64274502e071c1a149010"
    sha256 cellar: :any_skip_relocation, sonoma:        "d831d050f71b87f3eafdaedfd10b3bb0df4677c7fe9db02ad98b3941b84cf3f8"
    sha256 cellar: :any_skip_relocation, ventura:       "d831d050f71b87f3eafdaedfd10b3bb0df4677c7fe9db02ad98b3941b84cf3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a44ca4c2962507bc0966ba8597d50a0260849660ecc4fc0794ae0cd9f73dc5b"
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