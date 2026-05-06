class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.18",
      revision: "c5cd622ed33af00332e30630e90ab07037618bd9"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "844370bdd171cbd6a2219dfbf264662a03617453dae0c467095e2fd6cd6c4102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a43c2a0e9944a75e625ba30586d3af7b50f847fc64da5ed5553b55d4f31fc9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4855ac4658adc47580d083ad0ea707b2490b3e8988347e3096565b717cd66769"
    sha256 cellar: :any_skip_relocation, sonoma:        "3912e5936b76b7542c49e024f830d622063a3cccf0aeab985263b3776698a609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd98dbf578f171845a4a3fdad1f2db68f2993114e32cd5ce0e456e2553daf04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec24f5d12fed709879a68e3fd5c61a5d8fea51b5ca70610fea76fc23e2eaa91"
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