class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.113",
      revision: "8806707757878deb012f556e8ea77c0b37fc732f"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "934bf07aa95fd5c0234450b63797743f47dfc9751578799b5478d21559f4ba4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "934bf07aa95fd5c0234450b63797743f47dfc9751578799b5478d21559f4ba4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "934bf07aa95fd5c0234450b63797743f47dfc9751578799b5478d21559f4ba4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "df5302a36207bdceb59c75c8000d7bc71dd87796f2211a838284767802bfedb0"
    sha256 cellar: :any_skip_relocation, ventura:       "df5302a36207bdceb59c75c8000d7bc71dd87796f2211a838284767802bfedb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f12a86f170f027ad4a2e35d80e8eb3aa5e3064573f03e791505155dda18459c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f6e0d1d28d76e7663da3d8897a5e41884674e8536cc8b4535cb151a780e8ca"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.commesherymesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.commesherymesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.commesherymesherymesheryctlinternalclirootconstants.releasechannel=stable
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