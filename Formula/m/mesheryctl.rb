class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.28",
      revision: "279d518a59fbaad055bc202c1b17ec70dc26a5a4"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2af664516c1baf751657eb88976f4c5e61d2e33dd213d7b4a93a760ed67d701"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969be2aaecbe16db9e332534cbbb8dd2e16d5ca0abb3014a905eecdff3d2cee6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4b55580332adafa522b3c720f3383d607970a3cd2774e1bc9a4e99b3b1dec08"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd255ebd53dcd9e608032bd296f92d7b4e5f01082143bd7f378ee3e52fca01c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4806cd55db682d83f01825c836d8244c2752ce229d54b006f96a1bd41e5633a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6b3fff478006a285ed33059d115566ce0e79a1c7bf38772e327de546c1f555"
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