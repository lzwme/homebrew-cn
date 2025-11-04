class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.149",
      revision: "730d4179f086545dad8d1484d7480c5f60abd374"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67135a54803050671fae4f1fa821ffe48acc937ed8fba54a09f1bbd139c6a0be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67135a54803050671fae4f1fa821ffe48acc937ed8fba54a09f1bbd139c6a0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67135a54803050671fae4f1fa821ffe48acc937ed8fba54a09f1bbd139c6a0be"
    sha256 cellar: :any_skip_relocation, sonoma:        "f04947855ead42bc945a159517e1c3e0a4f87a292fcbe378df8c6546fb709d8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fcae3a854be6474a3c15d42f70838b64c6c735c868edc5739369b6d26bb0a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed62fc7b5ab0b37f5461477168f5134b3d42be761a96a66aaa7cbfaa091cfcc"
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