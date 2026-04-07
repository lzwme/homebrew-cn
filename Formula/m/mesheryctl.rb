class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.1",
      revision: "32bea3e108a70378faca7daa2ffaa9a5cfd66705"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f0dd1d31eac308e569201e82554d30de6e383e8884ed2ecb30e1cda58a9a5e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ab95c343dc8a94fc82665f604a983ee925a98e14591fe9b1b22ca50fcc2fa19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b2e5b96dc78c5105c42fcd857aeb170e5092ddd15086ad67bf035f5fd00c9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c20cf14b8d64482a72c506f46161b004e43564aaec75db9ba6da8c0c05be37a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfc5f6c885a8d29e9ec0d5637dcb9341fd16844fadf464fac5b25121604770fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3dcbc3e0bd878bbf2ed1723d44d0b08ea2a0126eb40703167b3fd8fc93f7d20"
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