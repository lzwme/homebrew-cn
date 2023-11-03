class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.171",
      revision: "9a0ea7e5d982be4c5714be8edf2f92c2521fff42"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc1c9187938355d3a504e5232a2eb53b06aea60af98dbae2e839878be7029d3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc1c9187938355d3a504e5232a2eb53b06aea60af98dbae2e839878be7029d3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc1c9187938355d3a504e5232a2eb53b06aea60af98dbae2e839878be7029d3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "faea2c109a194800f9e51ca1ec64ffce0f8faa45fa7217e19c1404eae2f426cd"
    sha256 cellar: :any_skip_relocation, ventura:        "faea2c109a194800f9e51ca1ec64ffce0f8faa45fa7217e19c1404eae2f426cd"
    sha256 cellar: :any_skip_relocation, monterey:       "faea2c109a194800f9e51ca1ec64ffce0f8faa45fa7217e19c1404eae2f426cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce81c072ffc266d289d4afe33ed9ec81870cf7eb41010c6c2fe7c6f238c4ca3a"
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