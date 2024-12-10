class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.168",
      revision: "77f56de7066a582311ebb3ffdd16b64dc1dd2e67"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29c91b5c8199f18eafbfd77cfa796400d8fd9c4e05bdae5c8103366a79a82ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29c91b5c8199f18eafbfd77cfa796400d8fd9c4e05bdae5c8103366a79a82ad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29c91b5c8199f18eafbfd77cfa796400d8fd9c4e05bdae5c8103366a79a82ad0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94b2d6d34b734c0c0c17143e1f615858575125a7a90c735cd218b30e7465357"
    sha256 cellar: :any_skip_relocation, ventura:       "c94b2d6d34b734c0c0c17143e1f615858575125a7a90c735cd218b30e7465357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc58362f9e0364555366ba61ee90c6534ae052bec979940f76788df2e05e8ba"
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