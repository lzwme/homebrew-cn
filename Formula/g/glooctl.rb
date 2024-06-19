class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.16.16",
      revision: "36a67914e969916fc66eb1371be501b4817320d1"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f29bdc94984f8e39d5a579c4fbbd612832f33cb8945e0805af3c110c8a235e72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03a8184bc380d8154060c06875dc18a373eb839e78a9756c622b4f17d3695c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "396fce556c97e24eff855c331517d08efe25c62a030164ec0b352951c6215717"
    sha256 cellar: :any_skip_relocation, sonoma:         "4323389dc9a8a4cc4e6f10c1259313193589da8b2e02eda81583d507a4dead02"
    sha256 cellar: :any_skip_relocation, ventura:        "a5e2c0fffd9459b5a2f7370f431e5fd3326eee69b40bc6072071e6b32040ad1f"
    sha256 cellar: :any_skip_relocation, monterey:       "83cfac632412925c221e497d51c7a369aaced729bd23da9b84aafa9388614b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61c6d4b3b87620911a8431f98428d808e64a0d01164c48bba17e48af132cdcbb"
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