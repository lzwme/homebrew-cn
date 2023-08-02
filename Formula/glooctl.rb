class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.13",
      revision: "08427518932cb9c0761371cd769104654c388548"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "497eb489912179996f8ea07cd3c8ee20a3a586b98f00d632fd4622445c64f19e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dd24df8df0ad1e0456c59904c77b36c9994420b51a8e553d4454c2de4816ce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f58750d0bb2e4056fc607a4d442b36c06561dceaf1e306280e90bccd50438e0a"
    sha256 cellar: :any_skip_relocation, ventura:        "39fe2bdf4031b2cd7a4b6dcb8b8fca89d3930ffe6f07a83a7997e244f07cdd8d"
    sha256 cellar: :any_skip_relocation, monterey:       "fe719ff9f15a276d2b2f7c0a24de17388b522394b8e37818b00e045b847668e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "58b713e50d60e471ff5990df3f01b817e80227d0aaea88f446a8da5cdbe7f18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3abaf6d3eba1e87c4b5aa6e9ab1e439a8a10dc02a59d8ccec334ec49f46cea6e"
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