class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.13",
      revision: "d9f563ce35e73c3da41e744ba1a35611f363591d"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e01f7b3f15b395848b820220e5ba147bc86d164ce48deab2cb2445ff82c2dc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423fb2b6264551d079c4525a894174dce4e0467e27b98132c8eede4d9125b5e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "212f517b5f0081a93d3eb535993d44cc7d754ac8095445531625d93ea22f669d"
    sha256 cellar: :any_skip_relocation, sonoma:        "90feec91a05b9d7ac7dac2af522a3a2c374fc33ecd11a7ef9e8d868c6ff2e63d"
    sha256 cellar: :any_skip_relocation, ventura:       "698c222bfab98c97e7bd0aa40d082359fcc2ed68856d6b0f81cd38e803b4824e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ace3e9ab4d85753c3366f172cae593040eb0be864e7bc7608f804acfff976a"
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