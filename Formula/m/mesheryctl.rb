class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.172",
      revision: "9ace7d84c4bc791d030b712ac494305a36d1071a"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fa15aeb0726c59009c27264f0e67a8b1da2876437e69de730f453a7d822527c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa15aeb0726c59009c27264f0e67a8b1da2876437e69de730f453a7d822527c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fa15aeb0726c59009c27264f0e67a8b1da2876437e69de730f453a7d822527c"
    sha256 cellar: :any_skip_relocation, sonoma:        "be82045bfb64f2acfb75d1d63910360b1da419e4a6b2e418b8c39676810de496"
    sha256 cellar: :any_skip_relocation, ventura:       "be82045bfb64f2acfb75d1d63910360b1da419e4a6b2e418b8c39676810de496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9412eb68bb24757ab1503e84440f95be37653289ef1b3870690ff83c06138bbd"
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