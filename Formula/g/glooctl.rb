class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.15",
      revision: "f371f9e342519ac4d1c637411ba747b4fb07ec71"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2a6206d3a66bfaeaf40e74311b85ba84a8f7118b66a1880afd3fbc675b9387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "358c584df6cb31f9ca5bf6a80dbf84255a6e5b73873a73d49150f7d227e050b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9c20eeca421a71a62d0377ab5f08d3c2167b451e2d71b48eba4b71fa25c4428"
    sha256 cellar: :any_skip_relocation, sonoma:        "0527b319d334a87100bee3dfb773df5851232866ace78114e24155779d58912c"
    sha256 cellar: :any_skip_relocation, ventura:       "87c69184a59c4a69ea54449be1968a297f98ca916969050d48ec875e0c61d370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77aa2741861a823b5305a2f2a53c955251e993ef05f02a4c8b2bfa7c689d71a3"
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