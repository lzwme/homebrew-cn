class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.145",
      revision: "2ac96959ef0188ad72a79f2630ee8d933afbf325"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c31cb3d440d56093113204a828d6c330a57f6d2aeae7fdf0462fe68c05a72832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c31cb3d440d56093113204a828d6c330a57f6d2aeae7fdf0462fe68c05a72832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c31cb3d440d56093113204a828d6c330a57f6d2aeae7fdf0462fe68c05a72832"
    sha256 cellar: :any_skip_relocation, ventura:        "fb159e275562c0d54a3b14749980b0cadb152ccf7578887313ec9f0845cded88"
    sha256 cellar: :any_skip_relocation, monterey:       "fb159e275562c0d54a3b14749980b0cadb152ccf7578887313ec9f0845cded88"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb159e275562c0d54a3b14749980b0cadb152ccf7578887313ec9f0845cded88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d654e6e2f07b0961b8de0caf31f3ba11109f070c1b0a28bf5dd1329f5162e22"
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