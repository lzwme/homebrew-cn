class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.128",
      revision: "1e4a66205585a26c33813f16650c945ac9503f55"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1852774acb1507e397d407312e0dc827216af9648598e1e2fa5e5afb10098511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1852774acb1507e397d407312e0dc827216af9648598e1e2fa5e5afb10098511"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1852774acb1507e397d407312e0dc827216af9648598e1e2fa5e5afb10098511"
    sha256 cellar: :any_skip_relocation, sonoma:        "da361b3b8c5b451d80ac333bb305a3d07ed383d150db3162e37369c34e87cdc9"
    sha256 cellar: :any_skip_relocation, ventura:       "da361b3b8c5b451d80ac333bb305a3d07ed383d150db3162e37369c34e87cdc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "725bdc7c3fe38609e19b65bfd873e095f31d648dd8421d1eda99267049024314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c869c909e9b4f7857862c088a3f6dd4887a1f0b054e90737a9085c9de6603c"
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