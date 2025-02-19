class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.32",
      revision: "a7326fce0141281727719de6506f9b2571b40957"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50926218905ed6499e6900e9958dcf7a39bda7a2418fca29df5f7e8f756b5789"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50926218905ed6499e6900e9958dcf7a39bda7a2418fca29df5f7e8f756b5789"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50926218905ed6499e6900e9958dcf7a39bda7a2418fca29df5f7e8f756b5789"
    sha256 cellar: :any_skip_relocation, sonoma:        "82c7743adc69a9be1b75131b4c62ff2bbc2cb46504593081fd43f2c0982dcb3c"
    sha256 cellar: :any_skip_relocation, ventura:       "82c7743adc69a9be1b75131b4c62ff2bbc2cb46504593081fd43f2c0982dcb3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "780f02f859f96d46416c3bd73b6a3655e490ae4b306ac634243ccdca2fdf454b"
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