class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.174",
      revision: "ffb780c1fe96c979b0a7ccfd7055cc31d94dcecb"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7238da13bb3b8ba5ee4bac52057346bc5dbe8828e652545bdc6693be145f1323"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7238da13bb3b8ba5ee4bac52057346bc5dbe8828e652545bdc6693be145f1323"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7238da13bb3b8ba5ee4bac52057346bc5dbe8828e652545bdc6693be145f1323"
    sha256 cellar: :any_skip_relocation, sonoma:         "325948894c860877db1921486a7abfab1e592e464a079ce3b18d8c6b472fba40"
    sha256 cellar: :any_skip_relocation, ventura:        "325948894c860877db1921486a7abfab1e592e464a079ce3b18d8c6b472fba40"
    sha256 cellar: :any_skip_relocation, monterey:       "325948894c860877db1921486a7abfab1e592e464a079ce3b18d8c6b472fba40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "434d2dc62cd45959282d40a275d8311f856bb28ad3ee8faa8b737b6768b4a6d9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end