class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://ghfast.top/https://github.com/openshift/osdctl/archive/refs/tags/v0.59.2.tar.gz"
  sha256 "5d7e2b75199dff10c492e4f367592a2005d67c032af5fb585e77b1f5079285be"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "112ca4c7ca727e2127f70b76b9c4be8d0eb1d9d056ab86d48bcfc94342fb921c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "112ca4c7ca727e2127f70b76b9c4be8d0eb1d9d056ab86d48bcfc94342fb921c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "112ca4c7ca727e2127f70b76b9c4be8d0eb1d9d056ab86d48bcfc94342fb921c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd25eefb22bfcdf4022be6d40142e33fe26fd603ebea58dcdf115bcc3425ee35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98064af7b252818e6f5693fda7df13db0ac08f27fe172110777cbe7c56a13171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87eaba6387ef7fbcba2bbfd5e5c967d407e80c5d889812626c4f499b7346caf"
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