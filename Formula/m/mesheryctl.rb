class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.122",
      revision: "6767ff4ef62d95eb3453de9a42d85c1a6fe36ce8"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "887142c7c6a7a0cafea2e684297b8cde6c12e22f1a38352f173bf4253557b97b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "887142c7c6a7a0cafea2e684297b8cde6c12e22f1a38352f173bf4253557b97b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "887142c7c6a7a0cafea2e684297b8cde6c12e22f1a38352f173bf4253557b97b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1880cf4cbf242ad6d040b4352c0d9d48bb072d62e59bcc6ccb8f5ba02991fdfe"
    sha256 cellar: :any_skip_relocation, ventura:       "1880cf4cbf242ad6d040b4352c0d9d48bb072d62e59bcc6ccb8f5ba02991fdfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a29b01e55854b37f338b8bd6426985940c271c29a90e08c6983acc4eaed23fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a525f185456b55ef4c98ad8be814b6750c92f459337a7545bc262d2e9b77f5c2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end