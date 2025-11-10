class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.157",
      revision: "2cfb6d80e145e50980d90bf14a08cbadb9d45ad0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cb3d39995a846d7426014d2ee4567b18d0fc30488d5163b6c902318bb54d42b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb3d39995a846d7426014d2ee4567b18d0fc30488d5163b6c902318bb54d42b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cb3d39995a846d7426014d2ee4567b18d0fc30488d5163b6c902318bb54d42b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3a449c397e6db53b8c708f62b989c121c9a9e69fa48ca59a126b377901602b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f78921827caa474c112f93fa67f25ca945729227784869804a2da0404da69c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c39f1dc91f70003f99c8bd4dd0d61bee9c852589ff07414b3dc06ab09f74774b"
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