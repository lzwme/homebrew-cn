class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.40",
      revision: "a7b46727adc050e95506a762490e6874709e3094"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e63e678ce2a7d597951717be1b523ef63de0a9f6b46d2c0f27535ca2ed28e049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e63e678ce2a7d597951717be1b523ef63de0a9f6b46d2c0f27535ca2ed28e049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e63e678ce2a7d597951717be1b523ef63de0a9f6b46d2c0f27535ca2ed28e049"
    sha256 cellar: :any_skip_relocation, sonoma:         "950f1601d8eb45eca807a152fbd92c05965dfb303fd029b43230b9debb44efdd"
    sha256 cellar: :any_skip_relocation, ventura:        "950f1601d8eb45eca807a152fbd92c05965dfb303fd029b43230b9debb44efdd"
    sha256 cellar: :any_skip_relocation, monterey:       "950f1601d8eb45eca807a152fbd92c05965dfb303fd029b43230b9debb44efdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8248d90605a37ba8ab949381457056b03e8fc232c77212f001ac31fe056ca469"
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