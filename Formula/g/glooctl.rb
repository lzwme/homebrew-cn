class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.20.4",
      revision: "2958882043c371a422c8fe964c4cef8dece7461a"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc1ab30345c27e86c17e9b73f438c5066afd059d57956da9cba46c50e4914239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc540db4b4b49d507bc5bf42665cda1af4ba9e7a7cc3baca6517620553ce3b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b070aaa40dc220a0842c4a225f4a8cc40518676cf756e9a7180e2e8f0d979b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d8c89d40c34915aca62d95936a105056c08fd7c24bd04c752761cb25b0d6c14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9195d0059339b5c8594ce0d7a923011a3f72d1c3403d7936cb707557d5406152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd77c122c91e6218a5db0f3f1657c5894c6d471a9307fa9bb1fb1d89902280d"
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
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end