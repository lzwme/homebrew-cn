class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.1",
      revision: "a4eedd26e5e3ffd7a6075f0852a35dca84f028b8"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25dc2c9264cec896b2972230715e2bf60f6ae9fcd649a8193f8acd5cfcef91e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fe497fcf16e6d0c25abdce5b0cafd12ee0910349c912bf3b02c75346026fd86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a72570e54f268208b7d83771b8c1624c67b6e93136101a1e6950a9ec3267543"
    sha256 cellar: :any_skip_relocation, ventura:        "d32c15c42a8b0fdfe6a5068ef78725264f74be2e55d6c5a764dc81e3e11fc7c5"
    sha256 cellar: :any_skip_relocation, monterey:       "85cd2d64df559c2496b46cecb484552367309de342fc502bffbb5cc7cb7e7df4"
    sha256 cellar: :any_skip_relocation, big_sur:        "02f2828a40f1cc416e22850d23d21354bc273997a5612099517b66f9fcc86739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1d59370b97ba0ee5cb56034c5c72b3636619c04b55e0713195c851799d8e046"
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