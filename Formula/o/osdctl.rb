class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://ghfast.top/https://github.com/openshift/osdctl/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "4e5f55e2945c7e25f0802597ef18eb0e3e9d6ec89489a2773461f6fb291f7305"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0527a9fd49817e76da639364cb75431d0d9efa50699cf7fb3067d827df0ca89d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0527a9fd49817e76da639364cb75431d0d9efa50699cf7fb3067d827df0ca89d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0527a9fd49817e76da639364cb75431d0d9efa50699cf7fb3067d827df0ca89d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e93d1878917da7ea2b9897d4ed8f813427fdc3ddf29800fba37712f1f68d1ffc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40ca1b26bdeac5717ef14948ba9ef8a5e78f0b14a6356e7b6863b72f2d3e62a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7d886ecc7b8d8ddf9c903086226116d988b8192dc13a5fefb59154429926bf"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
      -s -w
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