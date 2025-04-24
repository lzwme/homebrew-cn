class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.61",
      revision: "f95389d5beb29c8f147be4eb5fffeb29ded630e5"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d0f078887418d8801f9a83f96a19b2ccaa7ee286649c8b452dc69fa9ddcac3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d0f078887418d8801f9a83f96a19b2ccaa7ee286649c8b452dc69fa9ddcac3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d0f078887418d8801f9a83f96a19b2ccaa7ee286649c8b452dc69fa9ddcac3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "dae50247de428c948a2d123fa1178e5c848d3a148177e2e806fe7d9ad4665818"
    sha256 cellar: :any_skip_relocation, ventura:       "dae50247de428c948a2d123fa1178e5c848d3a148177e2e806fe7d9ad4665818"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a55aa8322cfc3c7b77710ab3d724c7f3aa7933b6ef0026104beecbf4fa232c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60bf86159b9113e9a11ebc96949440d7845aa25542aec64b30d8583282c5a884"
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