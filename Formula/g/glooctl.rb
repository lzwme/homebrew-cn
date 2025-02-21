class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloo-edgemainreferencecliglooctl"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.9",
      revision: "b9d791d5e4dfacd6d36537e6b4e65b72afd23c5c"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d359a5f08cbaab5fe30289bec4d85e6a2806a95935a4c6e6f803b57d4496507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa72ae51c26061dc865232bb1358e8a714c2f75d641d14818f01e223b1b17801"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b020f407da112695a95902b9aa5b98f325f33b9574c0300af00a13199374fd5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e5440b259f22583216b12678f463ca9302c3c3219d3edefdb86cad4d3a6ed13"
    sha256 cellar: :any_skip_relocation, ventura:       "eac5698a52785e370a30d1748707be0300ff30bb7b49b7e06a6fdc749195f3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab18e7f73d6b648e4433839131cd09a15cf85c68e2cf660fa6695a119a42809"
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