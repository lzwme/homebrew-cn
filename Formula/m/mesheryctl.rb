class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.156",
      revision: "cd8e7739629977205e458c4dc62999eba604dcc7"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84401dfdb13d07435e31d806119098ddeea22ea46f7ac8e55f12239301074222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84401dfdb13d07435e31d806119098ddeea22ea46f7ac8e55f12239301074222"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84401dfdb13d07435e31d806119098ddeea22ea46f7ac8e55f12239301074222"
    sha256 cellar: :any_skip_relocation, sonoma:        "89af47ded2ff8b7bcc1fce93f22b848e8e5c426a33f89f1866d73466ff52ed88"
    sha256 cellar: :any_skip_relocation, ventura:       "89af47ded2ff8b7bcc1fce93f22b848e8e5c426a33f89f1866d73466ff52ed88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b0923a10de7f75552e4624b6973f5fc6692b4008369a31d27ce7d2887508bb"
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