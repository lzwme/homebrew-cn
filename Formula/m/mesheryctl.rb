class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.7",
      revision: "d1d7a867ee6e719e07bd8b227ba0739439b4777f"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29976b1d1ac8fa4b18837b0220c630e995df723e89cb65cf4031d6d38f9819a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29976b1d1ac8fa4b18837b0220c630e995df723e89cb65cf4031d6d38f9819a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29976b1d1ac8fa4b18837b0220c630e995df723e89cb65cf4031d6d38f9819a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aa2d037166b9adcaa1c7e0fae7eeedf7d35ec385c8c4402c056352effa5c5c6"
    sha256 cellar: :any_skip_relocation, ventura:        "2aa2d037166b9adcaa1c7e0fae7eeedf7d35ec385c8c4402c056352effa5c5c6"
    sha256 cellar: :any_skip_relocation, monterey:       "2aa2d037166b9adcaa1c7e0fae7eeedf7d35ec385c8c4402c056352effa5c5c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2bc62f90ec75b9c7f46c2df64b99df4357fe084fdd6eae38214e4dd69fdc463"
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