class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.65",
      revision: "24870dffbc30339300f6cff66c6aad34452fca88"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4074cd854b646b0dbeeb17d70a05cb1a61566ef5646a49c7fcab79b140f85386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4074cd854b646b0dbeeb17d70a05cb1a61566ef5646a49c7fcab79b140f85386"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4074cd854b646b0dbeeb17d70a05cb1a61566ef5646a49c7fcab79b140f85386"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0381ad1702c5913963bb89b4cd4cafb936e888296ec79d52e9e97b04d45b047"
    sha256 cellar: :any_skip_relocation, ventura:       "c0381ad1702c5913963bb89b4cd4cafb936e888296ec79d52e9e97b04d45b047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa11a9d24014a143aad098007c931a8c5f84dde042973dddfe4c3ca184ecd2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca352437c65001bbbe72207773efb19d5a620b9edbf172d06a7f0a587f1dc7f"
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