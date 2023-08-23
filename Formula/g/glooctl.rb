class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.1",
      revision: "76781f0c5c9197c25be9e2f83c3a2174753046ed"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c14e43956c5a3ae312e2455ad64dc5477b69d8863b40a387aa984d7a2acf11f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c18cc8c69134bc1f17f66f05d590b3f2d38fdf71b64d71cefdada3cb4c50f15b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f3066971a3a3e786242e5a1ca8a4bed05e9670fda8e219ea6c411a92837758d"
    sha256 cellar: :any_skip_relocation, ventura:        "1d7c63a0b3f3cbbf728d4b9a7fd356dca8ddd43cc424060049fcfbdc3e5ad9b6"
    sha256 cellar: :any_skip_relocation, monterey:       "7d5ea9c57fc0cb11d391c43f1a0aea14576da340321c7452e6eb4b53a41639e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceccd4a79662fda55869f29681a23983205ff829d518d0a6686a2722b3f50f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3907b7762553bb46cdb2eb5d79172bb9c05bbb4da619ef0da0f066028d2e1b58"
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