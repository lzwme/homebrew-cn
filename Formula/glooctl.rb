class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.11",
      revision: "35981feee0fad8591df59b373a586820a49ce3d5"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b851bf717d821b3b9f146c0378a29c3999125363094e4f47f16f1e4ebddde89e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a98f4c3d0b23f630ee6d3c631a70a6d4de778a5d7087f4cfaf37cf2f8418db92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84050fd8c7334f0a0e8bfd1c4b09b686e9623fb55fd936b9d575dc722fa24a51"
    sha256 cellar: :any_skip_relocation, ventura:        "a7a0505bc2a84abc2e10fb92bd3d2139df00417120ecb574d6088e8141d5f587"
    sha256 cellar: :any_skip_relocation, monterey:       "9b60052f8d513664e550c7df4d0c855de4dbd843ae6996c29f514009e44786df"
    sha256 cellar: :any_skip_relocation, big_sur:        "9400a500fae664be64258aad7bba12e02eb297f25deccef552b9cdc43a935598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c97ba5e71d81a8b835aa3828245bb9f17350844394128c01f0bd8165c252538e"
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