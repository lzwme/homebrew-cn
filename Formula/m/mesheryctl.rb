class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.144",
      revision: "e1c289946e45fac5159473ee594c342c9d2ee9bd"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f8f9f9bd65b5ce4b8f0d9534fc63c952d90ec5e18629bffef2c5438550e6e14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f8f9f9bd65b5ce4b8f0d9534fc63c952d90ec5e18629bffef2c5438550e6e14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f8f9f9bd65b5ce4b8f0d9534fc63c952d90ec5e18629bffef2c5438550e6e14"
    sha256 cellar: :any_skip_relocation, sonoma:        "d92837947fc1f5fa0aa6857c4d01bfdadc7a00ab9db01a0d016dc8d42b624608"
    sha256 cellar: :any_skip_relocation, ventura:       "d92837947fc1f5fa0aa6857c4d01bfdadc7a00ab9db01a0d016dc8d42b624608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c0a9aee066fe0fab247e69e252a59a238fe9ef287faeaa194dbe74f8037ec1"
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