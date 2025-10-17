class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.20.2",
      revision: "460f9761062f024662044d2b122c1a0682032cf5"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94e18595ed26d81308e7efa882cf235ed48733b3c20ac1c525df7117f04c204a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31fbcc431d5f7a9335449430484b323184fb86186c3810d316b699685952d7ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0db88694098c0e784ae52dba69534a82a5298a550f0946030a8ced3f51066b49"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e7bd7fea751eaaf96a060f1a76fb9488b231a2a75ff0d0bc4c0e8d16141467d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cedadb089ca3b23b42c8329c520cb9e5ebad05d8a0bb98ca74d8c9d79d7d813e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4640e5d8cb84f7f36aa764351e6cd05b551bfc1f161dd05b980273784bcf2f2e"
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