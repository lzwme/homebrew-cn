class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.16",
      revision: "557766ab9208b0c632226edbf701088043a8d91a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15a9456bdd6f50547c44bb14cf32a2f6e21873eedc26aaa894201e8f0313dc3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06e12f1ee5ed986af5e879b9077cb02bdeebb79b322086652518d4ac9008b2e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc901816db7a7481f2d9b3ebd8d636c6e31db7469d32bfa730248188ba206a13"
    sha256 cellar: :any_skip_relocation, sonoma:        "775e0733b6c22b29e5316d9555d04d68740b25ffd60982490c21c0880afd42fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773fa92dd2e612c0155f03e9d8c9bc883ddee0bd02f36851a2aa436d89afa235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5981adf3e030c247648652fb027798162db0a981a72a035749cb13203035f9"
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