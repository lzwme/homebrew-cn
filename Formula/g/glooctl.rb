class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.20.6",
      revision: "79a4e04862fc0a5948bba9fc9db58d579480bef5"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "112e9b2730b0463456219c00ca7aeb6e5a13ef96316d4d1c9837eadeb30d44a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e06a5feae74d33ea92f8f4ff2655cd76ee68573c7f8b4b72129e489d597ca31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "108f1c8a279706487c3e78190337c46af16ea773636871803a4f6768d67ce49f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c691a81f35afbc0c044a598695b9de2000167d15206472137d263468861ea1b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4965b5755b7a8cbb196aa6c72d4eda392158b5e25614db7e8c945a063f4a4023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef3e9322280dad6dedd312c04230e1c399e78933d96d1a609e70f400a34cf3c"
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