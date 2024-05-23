class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.16.14",
      revision: "d895f83cf01011e89702975dcc12dff1eb6f8986"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9ce10ea6f1173135051a75510560602840e60495ef348c01a2f92a61319a657"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08923053096887c067ee2381eab6fbd5301f62dce7f9d169ecb2757e2d3ddee6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b9e7769fec00fd5abc9b5481ed9c054aa54514383839361b905c1f84df727d"
    sha256 cellar: :any_skip_relocation, sonoma:         "890bfbf1a01af61dd86e341714355048e3084751aec9b5914a61d2f31b9b0d79"
    sha256 cellar: :any_skip_relocation, ventura:        "91634c49bced8a855ceb50cbac4d2b675fd34b1a9c7be8921a02a5cbb1765d98"
    sha256 cellar: :any_skip_relocation, monterey:       "35631b0d23e415dad7fd4e976a84efc48bd98d5d819f867de70c22402d3abd27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa3fe30d2798c8836a4ea8ac78081d0b2534933b2160c97e3a369709248cb64d"
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