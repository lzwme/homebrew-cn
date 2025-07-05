class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.114",
      revision: "eefaaf0dc90717d4a94a39f4d2a8c30fb859bf31"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8cb21d16e71042ceba5047b4949d344e3feb7831bca0ca595fc121458a065d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8cb21d16e71042ceba5047b4949d344e3feb7831bca0ca595fc121458a065d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8cb21d16e71042ceba5047b4949d344e3feb7831bca0ca595fc121458a065d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d81d03609c7bc1bd120605757ac369628aff3880a476b4737d22ef3630908898"
    sha256 cellar: :any_skip_relocation, ventura:       "d81d03609c7bc1bd120605757ac369628aff3880a476b4737d22ef3630908898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e11be66644189b642fcf5411b22484deae78c789e5e5b25b88f15ee229b5ded1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78bcc1336014b9d763b1e160307f4f1c69675cd6ef662c875938cf4d0e26af72"
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