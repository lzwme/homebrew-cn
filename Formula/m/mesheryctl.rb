class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.6",
      revision: "1c37fee899b93b0c21241874fa9eda75a000ba5b"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e166c1527d06a986f18c5aefd29f66be90bba048f6c8a2e6757e8bab97d823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70e166c1527d06a986f18c5aefd29f66be90bba048f6c8a2e6757e8bab97d823"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70e166c1527d06a986f18c5aefd29f66be90bba048f6c8a2e6757e8bab97d823"
    sha256 cellar: :any_skip_relocation, sonoma:        "fec9abb85d8b1c69f9bd034f12027447d346e9b5758d2eb0cf9260189a61c692"
    sha256 cellar: :any_skip_relocation, ventura:       "fec9abb85d8b1c69f9bd034f12027447d346e9b5758d2eb0cf9260189a61c692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee94046e0aea5cbf043898692f86ecc92c07a25f90cb626b071ff84a030dde18"
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