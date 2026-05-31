class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.0.9.tar.gz"
  sha256 "45d15c57353b176388f23bc63ca1e0993643e8f238d0e591698070f85879c5c8"
  license "Apache-2.0"
  head "https://github.com/streamnative/pulsarctl.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to check releases instead of Git tags. Upstream also publishes
  # releases for multiple major/minor versions and the "latest" release
  # may not be the highest stable version, so we have to use the
  # `GithubReleases` strategy while this is the case.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70b40bc11639d940e3d53ec66b88223593378a4c093cc755e5541717f6c1d234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70b40bc11639d940e3d53ec66b88223593378a4c093cc755e5541717f6c1d234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b40bc11639d940e3d53ec66b88223593378a4c093cc755e5541717f6c1d234"
    sha256 cellar: :any_skip_relocation, sonoma:        "329a6f2345b1dbde50f02691357b2e9cc2a6ad9b459f025ca6d67f919655f925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e312fb3d51c5abafeffbccfc4e8de5968467e3dcaa196d29f044d393890359d1"
    sha256 cellar: :any,                 x86_64_linux:  "497ca1469d4cda1f07bcf16e9a8c812e34e27da8a2e75f3a85703a107906b63e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.ReleaseVersion=v#{version}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.BuildTS=#{time.iso8601}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GitHash=#{tap.user}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GitBranch=master
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pulsarctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulsarctl --version")
    assert_match "connection refused", shell_output("#{bin}/pulsarctl clusters list 2>&1", 1)
  end
end