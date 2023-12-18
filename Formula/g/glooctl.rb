class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.15.17",
      revision: "ad5d31ca4673b27344840156253b035ba8925ae0"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac6a0306ce9d15693a90f2d014df57b2c34a718763e1a63c5b5059bada00a581"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f8588802349e12daf3604aa772235bd3224839b94bcdd16e0dd6efb39e41497"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71b7d8d1923ae2e6cc241720d5460f06a195edaa484ee906c9988d7f949ddfba"
    sha256 cellar: :any_skip_relocation, sonoma:         "63a9086cfa2cd69bd38749fb0e8a9bcf642c534e74792b7916903c5da03f52ff"
    sha256 cellar: :any_skip_relocation, ventura:        "89477f12f6969df5d7734804d37c660b530d58a9fb1fc4dc7cdedd3e240376c8"
    sha256 cellar: :any_skip_relocation, monterey:       "149232a18cee6f4ecb8f934742c3466a1479200dc07c945a5e3d888098529d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46af9bebb4c1b876d4f2c78b0330f88f76c82759b44e1295b03a328c55dba848"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_outputglooctl"

    generate_completions_from_executable(bin"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end