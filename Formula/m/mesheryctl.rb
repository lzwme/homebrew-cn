class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.57",
      revision: "be4206fac418d07abfa0e53ca0e231a64d4a9ab8"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9523cb73682eb1a7495284c975db7c18678709d395943378d19aa5796b21a110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e750f9e40d9c035ae77e91708711d6c4f8ec5c83bb7fb4452c9e21aaafce2711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf07a693e66a03611e98dc5929ec17e19676218ce3c4e06513571868ee2e57fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "97ef17426fb7ed09de671f07144e5884af57aeab53291e8ce44a94d8f9d189b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdecd2cedcfd95864d3209c8a2597afcd033dddbd04468307a29e341222529f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa419db169d2196c942d1aab15c256c4bd15f4d19831f3a48b8017c414312493"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

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