class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.19.4",
      revision: "38ee810beb4e439d17041a7bf9b543b69d9c975a"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36ccf24110baa45b7a8fd8a4343be2fde871cad7ddd753865ef2e9bcc9fa8adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab40a3a641a57eaa7c34c4cdca28fc2b74c468beb40e1fb182e78c23d0cc8b28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60412ea05941c7df5d609ff9fc71d67c189b5af8f752de9198e5cddb611739ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "1778975855443acc35562211a798cf9613914cf8f69b1a7b66f4258c5049d9f2"
    sha256 cellar: :any_skip_relocation, ventura:       "d4307dd4cce28b92d809d10000a99af6bc99d6b7ee2213c84308b936ed5014d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "180402f144a59f4d374b761ec2f1ec09db08171de4a9494d5e0f97564097ff50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a47d2cbb8dab88bf3a3cb70c9cc25c762801eafee1ed4c1fa76d2901fc3cc974"
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