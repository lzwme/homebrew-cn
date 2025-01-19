class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.18",
      revision: "e0c1e2ad48c863b0f38f5456a5eb6956098903d0"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5217755f3135c2a25f358434762d23631c2ffb235bfb2eee25cf748a3afd7f27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5217755f3135c2a25f358434762d23631c2ffb235bfb2eee25cf748a3afd7f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5217755f3135c2a25f358434762d23631c2ffb235bfb2eee25cf748a3afd7f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20df993e08e11763ae11066620fd35017b4a6c1637ccb0c506d47df59ac6d4c"
    sha256 cellar: :any_skip_relocation, ventura:       "b20df993e08e11763ae11066620fd35017b4a6c1637ccb0c506d47df59ac6d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16a68ad98cd559f2c513db343c4ff4894a7701e5fc35a0f184c2296e5ab83392"
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