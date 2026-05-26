class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.29",
      revision: "0ea410a513879c8d453bb28695624bcc3711910b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ace332bae5361bde7aa8f48b1807e954ddc221bed80760b843d6bcae7a2593a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6adb70bd423e86b5cbd9e56ace85aa8edaabacd27b38e9a3ddc681fff56dac44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f8b893442004a9b8c3a7bed8fd13b0cfd91fbc777a9947bf0d6d93fcabb01d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7d6f4e5952e39ea01780a6cdfe447e009030bc77b9064a664b3eff4d0e5bd7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cce428b4a5e736667a5718118ab1c877cd1deefcfa391a026f5a70f48a9e5cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e861b42123122f7e288b6854a58910c40c02609b07b934d8500e7e501acd6e"
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