class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.59",
      revision: "15b953b87a5fb5e0b56599d845417e38cbe86deb"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66dc9d7c8615dabe55668e2b3d51ce74ed309d68c5b5155be35f1f084b2ee9ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffb7fa8465188cb7d5e15b57afdbee7167d16d12228df93aaead46f51ae51e95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff9b4a70a74fb9de5697cd31e49ed0902a1073c04c1f6e1ff259c2b2206b5e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "52413d006e6f557a10df3c92481d6af8906a59640bf418ec5405b29eb5066b2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4dd7ddec0807bd46437d0cb90e2f09c91b8ceb82f7fb6c59c58554c75f2fb15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a15a4c3374a7dbb4ba576c4989f7cd3c7ee22faaf11e1423bc58bc24f88d7ce"
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