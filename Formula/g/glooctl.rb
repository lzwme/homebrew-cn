class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.16.2",
      revision: "a7fbbf3aa1045cfc55cc2d55de1013eb7cf8b362"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a03bfba3ba930c12b146d604bb8bd478d09eb855095e35196e561ba4898bfc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4232cf1a1aa0ef999fc75106037f1aabf2199c1c7fb9ab478490164ce844bf42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c592ab3a62154bded53adc828df8aaa6ef0f1fb474c5a805e5f8c564846b831d"
    sha256 cellar: :any_skip_relocation, sonoma:         "29938a168ffbda447007f012d7c282db204e21ead05872e5db632ae35de916bb"
    sha256 cellar: :any_skip_relocation, ventura:        "183d26b9c1bd61331894f80b49807b325d6cfd4a796c09b6921718be9500f1c8"
    sha256 cellar: :any_skip_relocation, monterey:       "2b3627b0c93d09b4999905584fe3b3c529ce3d6baeb0b879654a25c01ec5a7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca839d0f0baac75e5e0c2bb4ca4d53346ef0dc10845198c4c38bd099e6fb9836"
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