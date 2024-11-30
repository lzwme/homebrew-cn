class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.166",
      revision: "299face0cc6bd72c4de190d8b88c56e544fd9faa"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e21856aada6ae6e963dc057615efa519d7dc08b346ac049044fe71424fa5ac14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e21856aada6ae6e963dc057615efa519d7dc08b346ac049044fe71424fa5ac14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e21856aada6ae6e963dc057615efa519d7dc08b346ac049044fe71424fa5ac14"
    sha256 cellar: :any_skip_relocation, sonoma:        "f52bf295e12a1b357638efb29ad5f98d71073d420ea842f504c5e94610d72b98"
    sha256 cellar: :any_skip_relocation, ventura:       "f52bf295e12a1b357638efb29ad5f98d71073d420ea842f504c5e94610d72b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9538fe1439a373f2878a3fd71f3694422768cc071c14bf6b96033f6b22be97b5"
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