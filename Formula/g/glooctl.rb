class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloo-edgemainreferencecliglooctl"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.7",
      revision: "d94c3757b92ecbedfb88eab8d303a8304831f229"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36d048ea5c407fbce0d0aa2c6848d60f9f9a9b7f4363e166ed2a38b7384d0d03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22da39fd696f41ac9ac274aadf425c53ca5362b83966f8dda76ff63af42507ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "256c04e076272eda586c34d805740682e2cc73ce2aa353ac540d6eae76d55093"
    sha256 cellar: :any_skip_relocation, sonoma:        "2936c0c30b0c3b3493e0703cebddcb2047a0af25b14702f130d5a2037924e8d2"
    sha256 cellar: :any_skip_relocation, ventura:       "d30e37b66dff6d5d5a69f19494daf5a49006c2885799016b75fb456a23431155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4a990dd93efb607568c8237c8670128f0c0309d1294cb40f5e2635aa712e844"
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
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end