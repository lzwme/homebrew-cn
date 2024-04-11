class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.46",
      revision: "5cd80c5033e87de56084b48c5f75fce708d2b499"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9322df3918ac184482872dbe0c7a6455e8795b957dddbdaa48b0c566f65eb2a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9322df3918ac184482872dbe0c7a6455e8795b957dddbdaa48b0c566f65eb2a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9322df3918ac184482872dbe0c7a6455e8795b957dddbdaa48b0c566f65eb2a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe985eac138bf0baeaa22e9c298da92a3ae58ce11096a216b056267b33c7ac25"
    sha256 cellar: :any_skip_relocation, ventura:        "fe985eac138bf0baeaa22e9c298da92a3ae58ce11096a216b056267b33c7ac25"
    sha256 cellar: :any_skip_relocation, monterey:       "fe985eac138bf0baeaa22e9c298da92a3ae58ce11096a216b056267b33c7ac25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bd0c7914c28e03a762eac2c953ccb51e793fadd51b958cf1b52f6f8b10da32f"
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