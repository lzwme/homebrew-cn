class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.135",
      revision: "1600644f1dea37091f6234f594123959d19aa7cc"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272048b4efed31e7075a783f9c76cb068b1adc07957ee4e526c9b7ccf5a59134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272048b4efed31e7075a783f9c76cb068b1adc07957ee4e526c9b7ccf5a59134"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "272048b4efed31e7075a783f9c76cb068b1adc07957ee4e526c9b7ccf5a59134"
    sha256 cellar: :any_skip_relocation, sonoma:        "3706a383278e7d72663ea53a87891af1e54c30215814f4852a3dc76afdb7a183"
    sha256 cellar: :any_skip_relocation, ventura:       "3706a383278e7d72663ea53a87891af1e54c30215814f4852a3dc76afdb7a183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67491d77159dfbbf5202cf409335fc030f6aa86471c4e754f2bb19ce3d96c629"
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