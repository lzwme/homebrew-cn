class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.16",
      revision: "36c4ba020048c4556ef8650d011ddb16368a4fef"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f198f6ae963cd60fc32f637b20d1cd841adc674f2a06120dcdfaefea09108c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6d56d3cb0bf7347d0d6395a76c8a5eb74f1e1f4402560bef21e99d2df0af5e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aef7456ef4d56f15fb1ad9063c634c1b6909888e345a448c8586823c5c0a893"
    sha256 cellar: :any_skip_relocation, sonoma:         "5eccf5894c647f19dc4a223e539cf88a4b9605c78c1ec8240ea6c05dd2f239fd"
    sha256 cellar: :any_skip_relocation, ventura:        "73017884bdd0876da7895f632e22a5d08f7f537b7d49d2dcde04d5bcaa78dc17"
    sha256 cellar: :any_skip_relocation, monterey:       "5112097a34429d62100c6143aa2dd55bc809f1b4c5ae72b7bcd108b595c9a490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b8a896f5d4636a16ebfc8a12617c775d5d0afecc2a17843cf068c1a9cbd78c"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end