class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.3",
      revision: "99e1ba793afc2708e74aaa69bc14938dbc64894d"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95d1db04f9f082cedb3e0d3d4ac5ed944f8b300d458fca2f9040aa9f619a9cfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23a01f74f027109f78699bce0611773dfdf933dcab3ce9628b76f68b6560c91f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cec715d05066b5a1243b7587a7baa09b041e17bcc85ce104d62e1ee2121a8909"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f9e45bbac92189d0d7412a816175633d358d5d39e90f2aa10492ceca1f6b63e"
    sha256 cellar: :any_skip_relocation, ventura:       "a48784df24035aea79468e9d59d63ee919cf1ab425a98bf57fe3f29e03448cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140579c6c0e40ecf42a0166a0181a0fd0b05036f248fe5eb33c2f249ccdecfbb"
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