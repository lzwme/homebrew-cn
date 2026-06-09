class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.39",
      revision: "be898a7ae1e04550340376b02b169a7bbfa2d067"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "910e59236dd2fe4e8af431ffe3f514f9dbe70eceaefdbf908e0a5170bb98762a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ef9498bf7bb4c294726d4eaf23ff2f85971217da83d472643e5ec21ebfd8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfe8850ac1f363feef942cd99a558d5fb960a39007b59cea83fa50d3db7b826b"
    sha256 cellar: :any_skip_relocation, sonoma:        "58433fb21a62d37248df782802050bfcd975204cf48e9c1184ebfec324f37f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7de6a4b6ce6a1298f6e11e0a78d89f1114143356640e068175b2cfa3913abd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f74668bdbc6b8026fed94aa5e509a574dca9ef71f112713bb7853bdf6151c37"
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