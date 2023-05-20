class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.5",
      revision: "d5db25164561c8b215350212bbd69d7faa10d6c0"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e88132e4f024636afe4d6f7a67dcff1695a59d1a682183b58f5f84f51d1462d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54532819b3f4d7778914a95704a75e7f04da692ad08839f7a30dc774039f598"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68775c5728d77df343f7d29c9ccbdbb972b2d0c0cd8b7317c6a128e5bd70ce93"
    sha256 cellar: :any_skip_relocation, ventura:        "a16de7f1e568274c4a6ee2b12e27e951076ddc01dc6439477ff82431912569fd"
    sha256 cellar: :any_skip_relocation, monterey:       "14f67d1d24c78aeaae772de94502b33e8ba8883cae10577cde3418e6ae7dc66a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a323adc910a05fa5536c4954508dee8da7068076b8972aeb4a7e9534be739eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3fd6100aa35e7664d65d883e6389afdfe7d9c3f0312a05245e1c66e4c2a1018"
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