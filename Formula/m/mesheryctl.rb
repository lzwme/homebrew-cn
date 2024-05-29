class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.66",
      revision: "edf5f7b5bf9e0ae5e0e3577379739641bc9abc63"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44a92cb70393b61c707ce904c670abdd490ae80b4c4ab87e0ccd951399aba8f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44a92cb70393b61c707ce904c670abdd490ae80b4c4ab87e0ccd951399aba8f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44a92cb70393b61c707ce904c670abdd490ae80b4c4ab87e0ccd951399aba8f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2cc3906ee08ca9b23f69672dba0062aab792f9b5c72d40adc4ffb3efe2aadff"
    sha256 cellar: :any_skip_relocation, ventura:        "d2cc3906ee08ca9b23f69672dba0062aab792f9b5c72d40adc4ffb3efe2aadff"
    sha256 cellar: :any_skip_relocation, monterey:       "d2cc3906ee08ca9b23f69672dba0062aab792f9b5c72d40adc4ffb3efe2aadff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc793ce945d84cd4b0a07bcc32ce96f4497dbd48b1cff6458540b99ba83226b1"
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