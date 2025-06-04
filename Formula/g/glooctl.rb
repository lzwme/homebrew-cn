class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloo-edgemainreferencecliglooctl"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.19.1",
      revision: "b01eac6c5d8a9566d3ac96904e8135db4f628090"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e13c0f5bc52baee4d6165a87a187c159b74b0ca5c8dd4bcd8303e5a8d3e6615"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36a2c68a170960601144c5a922704f65559cd5e192e4286c123de8e4ea3d506d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a639d110079fe6795fea9794a0bce3265256ef50a4da8c8e0270b13b067f8e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff790216831eb4cd9a9abb9c655939008c62465c4f7f741e30ebdc6967abb68e"
    sha256 cellar: :any_skip_relocation, ventura:       "878a2d26f56df5048151b592d727f20bb3b0f15edf70943e7c18ea1507bd354e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc232c8c1d7c5393feabb152f0e8e3799c7dcde234ca7d65a079a1daadc10fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2894802fa1fc07e1eb91f0e83860ecf4512856c619fea901cf88d54d64536b"
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