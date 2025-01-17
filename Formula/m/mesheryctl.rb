class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.14",
      revision: "8b229b98f0b030f81c16106f8d9eb7224563c297"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b1db31efcc7726d430ed9f9712b55cf94425d176fa4dfa90b409b434e5913c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b1db31efcc7726d430ed9f9712b55cf94425d176fa4dfa90b409b434e5913c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b1db31efcc7726d430ed9f9712b55cf94425d176fa4dfa90b409b434e5913c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "51dee6775f0636952e85f5d3e3e3ae10e2bdf3a7d23f46818589f7c82bd8bdfc"
    sha256 cellar: :any_skip_relocation, ventura:       "51dee6775f0636952e85f5d3e3e3ae10e2bdf3a7d23f46818589f7c82bd8bdfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54cc4476d7fd7703d5cd0f1b1f4549da54f76d1e1baa112a9d5a4f4827b8ff15"
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