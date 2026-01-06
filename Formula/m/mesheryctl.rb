class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.195",
      revision: "08448c2d234346cbf58ff7ed9ba280dddfa95aa1"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d15634c36c02859acfd1ced838f13faac08d3c969c4b9e589e010f29245dbf16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "718edc790855bf3372c9f558f6d86b465373523d67c22d64317ad6a4048efb62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7953c5893568b72078f872bd3ccda0a9a103d2f1aad2dc47e6f27df5d8bb4690"
    sha256 cellar: :any_skip_relocation, sonoma:        "48ee00a147e54b1072bcaa2d941a429768c7e011ee9c076e6a57b22467a9979d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d002960f2b95d88fba797cfa3b12547c1bd003f9e17184b4dcebb003d65666c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78c8b4a83bb1bc8819246960be2b7a584b6c486bd52660ea9ca043ea5e7e38b5"
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