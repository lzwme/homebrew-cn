class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://ghfast.top/https://github.com/openshift/osdctl/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "2e16cab11da13200abb799675fb96efa54f82efc4cea32482d7e6a526bc5472c"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  # TODO: remove if undeprecated
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35186d0629e364464e399c98eca2f850fa4a74f5582857032b7654b04bcdff2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35186d0629e364464e399c98eca2f850fa4a74f5582857032b7654b04bcdff2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35186d0629e364464e399c98eca2f850fa4a74f5582857032b7654b04bcdff2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2984c5e341acad716455cbcbdc308e8228e400de09e566a51af492c2e842006c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4d08676cc4091147189762132b012dd121a99e90cb7dc7340cae6f21c7951ce0"
  end

  # Can be undeprecated on new release or if upstream responds:
  # https://github.com/openshift/osdctl/issues/963
  deprecate! date: "2026-09-18", because: :checksum_mismatch
  disable! date: "2027-09-18", because: :checksum_mismatch

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
      -X github.com/openshift/osdctl/pkg/utils.Version=#{version}
      -X github.com/openshift/osdctl/pkg/utils.InstallMethod=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"osdctl", "--skip-version-check", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osdctl version")

    assert_match 'Error: required flag(s) "cluster-id" not set',
      shell_output("#{bin}/osdctl --skip-version-check cluster context 2>&1", 1)
  end
end