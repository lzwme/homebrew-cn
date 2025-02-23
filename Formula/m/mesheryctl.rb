class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.36",
      revision: "2b693f9667e5f26785c880cb912d7037b4ba14b1"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13719f4ef32a4c6868df094ada022824e5e4951b5a7a7b90d1d98874d34fecae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13719f4ef32a4c6868df094ada022824e5e4951b5a7a7b90d1d98874d34fecae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13719f4ef32a4c6868df094ada022824e5e4951b5a7a7b90d1d98874d34fecae"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2494a22a48e9638b7d9671b7bbcead060844aaeb1f37d13d09c090e3fa7817d"
    sha256 cellar: :any_skip_relocation, ventura:       "a2494a22a48e9638b7d9671b7bbcead060844aaeb1f37d13d09c090e3fa7817d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe0391f0e298e13118434f18e27cb1a540ef7707463e0c2be431eb06c5309e8"
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