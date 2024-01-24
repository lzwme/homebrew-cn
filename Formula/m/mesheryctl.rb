class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.12",
      revision: "b378f9820d916efdea0c631bdd54ebbc83bff0fd"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b784caecc7fc247a5b5041219c316176d466182219ce56444d9e9b514602fdb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b784caecc7fc247a5b5041219c316176d466182219ce56444d9e9b514602fdb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b784caecc7fc247a5b5041219c316176d466182219ce56444d9e9b514602fdb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0d67acc1d68fe5fb7d9ce050620a05981f3aafd830bcff6372ef8af7976ba96"
    sha256 cellar: :any_skip_relocation, ventura:        "f0d67acc1d68fe5fb7d9ce050620a05981f3aafd830bcff6372ef8af7976ba96"
    sha256 cellar: :any_skip_relocation, monterey:       "f0d67acc1d68fe5fb7d9ce050620a05981f3aafd830bcff6372ef8af7976ba96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dafd46e5cf7622ecd1617b534c407586da9a432c4fc3c5dc0750bbb3f6f6646"
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

    system "go", "build", *std_go_args(ldflags: ldflags), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end