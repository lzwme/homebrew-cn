class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.86",
      revision: "c1fab804a4b34fd16955a35646e0a48752f81360"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43a6ddc5e04886bc9f4d09ddf508baadbe0846e08acc599e2440f8a127b4db36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43a6ddc5e04886bc9f4d09ddf508baadbe0846e08acc599e2440f8a127b4db36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "187703180c1c0fb62ca2b036c5afec0b0b8a7a64cc05687f9c9ec5d0382cce2f"
    sha256 cellar: :any_skip_relocation, ventura:        "c71d1129fc439b161b989fef6212062a1d3a08afe66c0303964312409993648e"
    sha256 cellar: :any_skip_relocation, monterey:       "c71d1129fc439b161b989fef6212062a1d3a08afe66c0303964312409993648e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1ff07256dcf4bd51038ba2273e8c532a49fba10367dddde9d9353195ae3ffe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5982f76125bee593fbdab8262ef7f3d71f960cd1092bcf7f0bbc187b42c3bc8e"
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