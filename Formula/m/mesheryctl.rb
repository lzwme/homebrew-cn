class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.48",
      revision: "ee4e101968dfb55bc56d7d9e827dbe6dab344cb7"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f148b13b482955060a07d6c51c3bfa77fbbed930654e78471ed51275741b4ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f148b13b482955060a07d6c51c3bfa77fbbed930654e78471ed51275741b4ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f148b13b482955060a07d6c51c3bfa77fbbed930654e78471ed51275741b4ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "55cffeb32cc816540a591c76e7422e6457fe01b940d9e442fc94dd77557f3806"
    sha256 cellar: :any_skip_relocation, ventura:       "55cffeb32cc816540a591c76e7422e6457fe01b940d9e442fc94dd77557f3806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1839f4aeb1dacb8e4239f1d68165469c4bd67e520f0ff8724dcfcd84f106d626"
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