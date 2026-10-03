class AwsSpiffeWorkloadHelper < Formula
  desc "Helper for providing AWS credentials to workloads using their SPIFFE identity"
  homepage "https://github.com/spiffe/aws-spiffe-workload-helper"
  url "https://ghfast.top/https://github.com/spiffe/aws-spiffe-workload-helper/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "83dfbfb0288dc79ed75968e86fb5ffe0bdd99f94a4ccbae0bf4677cf4b010bd5"
  license "Apache-2.0"
  head "https://github.com/spiffe/aws-spiffe-workload-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b19ea518bc0130349fb38eab5ececc8a6c3db7bbc708dcdc755e8d92c7881596"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b19ea518bc0130349fb38eab5ececc8a6c3db7bbc708dcdc755e8d92c7881596"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b19ea518bc0130349fb38eab5ececc8a6c3db7bbc708dcdc755e8d92c7881596"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "70c82193ba68c5d82f1104849fba935facc4e15b1c251f83aaf29d1c8d2067a4"
    sha256 cellar: :any,                 x86_64_linux:      "b85539082c2a3120c82124e60990f6ebbba37d280ba778faefef842391565c56"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd"

    generate_completions_from_executable(bin/"aws-spiffe-workload-helper", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-spiffe-workload-helper --version")

    output = shell_output("#{bin}/aws-spiffe-workload-helper jwt-credential-process " \
                          "--audience test-audience --endpoint http://localhost 2>&1", 1)
    assert_match "Error: creating workload api client: workload endpoint socket address is not configured", output
  end
end