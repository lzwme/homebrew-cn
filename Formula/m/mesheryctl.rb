class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.127",
      revision: "8bbd75e4325bd8760bb162f7619c8d771d29f609"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef01358d83361a1c947a33ce79d9392abcc9f4e1cf9fc4f29d3d89b8a58e4f36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef01358d83361a1c947a33ce79d9392abcc9f4e1cf9fc4f29d3d89b8a58e4f36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef01358d83361a1c947a33ce79d9392abcc9f4e1cf9fc4f29d3d89b8a58e4f36"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be01bb3f63b4ab942f517d6ed590cea88a2c8561be42895c5bc9d6f6a525322"
    sha256 cellar: :any_skip_relocation, ventura:       "9be01bb3f63b4ab942f517d6ed590cea88a2c8561be42895c5bc9d6f6a525322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95cc08c9d22a0c2a8d45b80117515a1c9360514261cf86243239689b3b1f3d44"
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