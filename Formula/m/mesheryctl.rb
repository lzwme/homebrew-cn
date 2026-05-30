class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.34",
      revision: "12dc74dabfc2f1c6cd74532ce21568f9a599cdaf"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81344322f8c10fbba7f363f8e5816c6ed67fe47d5df8853e89a69bc9c97ece30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a070e17f6b122967eae049e1894f0903bf285bc8f8fe8b9cafe8043e3397846"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ff08aa5924ac57e3beb9c67d4f1608938b7b76b3aac0edf504694139f90c09"
    sha256 cellar: :any_skip_relocation, sonoma:        "b592e4ad25599c0febc95c11c2f0df1c1cefbb6dcc02e20b48427c10ec5f3f74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93f8f4d448941ee538990cd4e1d3d780862ad1e0190f26d4b92446e7a9d95797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bebd0d5b3a3da415c20a4f27298000a0ed123dd4794c4363bf9d87779488a71f"
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