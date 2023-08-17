class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.15",
      revision: "c0fea7c4b4811b0b70a0bfb3f2387b2f0bf891ea"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36aaf8ff186c52ffe4efca22ac5a0306d36dfc72a20664d4516b5ab79169aa54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44a25c5efcb849779c435fa8eea95d62e8f38d59317f6dc8eeafc6234453d7ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "055f4a51c92a4e37a3ef587824e3005f947940e2bcbf5ca9e4bbe8d014eb2266"
    sha256 cellar: :any_skip_relocation, ventura:        "2f8cb3f60cc5dc22acc6bc247e836ca4cbe3bf2cd37c104ca77b88e1d3eb22d5"
    sha256 cellar: :any_skip_relocation, monterey:       "9c2991a2aa7b0ad49c3931ea18c0f8147764f031fb3e5ff94c8c632e41d56be3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f375e0286d481f16da1fe87cbb6e33a84892d7aef0789ce9b81311016baf5157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4251250e3b306100e09c438406fc55aeda3ddee16bee3fcd71eb4dabb0ff57a6"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end