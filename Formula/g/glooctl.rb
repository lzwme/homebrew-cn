class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.11",
      revision: "aaf7410342f44c3b35b928860c86904f7cc7ffe2"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e124db86f02727ab829680c618ec2d8964e44e20ab7ff8cf76e3fb743bf62b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ee9516755064d5dc35b4d34de03e06089af3b9c5f5bbf2c8bb2e42a0bfb47d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dda4e80214546f307c10d83a16abe024f14bfb779e24a18fe0a242b15bb85a3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b09bac25a86bb265dcf88c3eafa294f08ddc5ed01b5ce2f0ca840211ab1eb58f"
    sha256 cellar: :any_skip_relocation, ventura:        "1096a987158a2a387ec8abb757b76b03dec59e7b6ac8aeee22e1e01876d39e99"
    sha256 cellar: :any_skip_relocation, monterey:       "4439b736073ecab50e86fb19fd58e624cfd32967f8a23278ff6a65b8166712b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94f06d2eac468df7bc94360c672807a678a2e7cbc4ab5457f9280660c1b52586"
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