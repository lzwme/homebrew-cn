class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.170",
      revision: "97c30ced3a6d509053cc6b87f58c7e048581d596"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7ae859b99e7ac752450574c22958d9a83662a7c7131a44a3af53d3aa68e8258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7ae859b99e7ac752450574c22958d9a83662a7c7131a44a3af53d3aa68e8258"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7ae859b99e7ac752450574c22958d9a83662a7c7131a44a3af53d3aa68e8258"
    sha256 cellar: :any_skip_relocation, sonoma:        "27ce33e714a06a9c30ae3b351ee4a81d747856e8a7045664cb7036740d462b3e"
    sha256 cellar: :any_skip_relocation, ventura:       "27ce33e714a06a9c30ae3b351ee4a81d747856e8a7045664cb7036740d462b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7a351a48f63f5878bd2cd65d28bd799423bfac9165ebff6f92e8b38a760083"
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