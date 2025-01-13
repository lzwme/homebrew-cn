class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.4",
      revision: "f69e89920c71b93e67484cb0d6f68818b67909bb"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c0b581c06184e304fa09d2d79366b05f3d16182c29e716135b2c4484a05a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd37b90d26715ca5c2235cb75def2c522c3ddc7cf33e92dca0b428d0ab10d9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cea791236ebf75d00d18130de01b93cb75a7596a388ef708896d108c827647ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf1237fc842ec0509a8463d11dca7915573e347c8892e6afa645e25f04cd5c8"
    sha256 cellar: :any_skip_relocation, ventura:       "bf6cd562ec489c201f8fdd9488257ce3217572683c4b00677bbda193d3a6b96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910e520aa437f67d45c86da1a4f097302f21954cfd1f515514ca5f4fef009864"
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