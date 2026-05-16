class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.0.7.tar.gz"
  sha256 "f6b925c777d4d77bc248554827671159de09d496ef79cceef0f487f449a2e66b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef3571ecc719c04b0d4baa53e6d82c74f6053e2216833487bbffbdaea733c87b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef3571ecc719c04b0d4baa53e6d82c74f6053e2216833487bbffbdaea733c87b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef3571ecc719c04b0d4baa53e6d82c74f6053e2216833487bbffbdaea733c87b"
    sha256 cellar: :any_skip_relocation, sonoma:        "95253b1f57628f6db5cd2a901e9f6d5d652efe5c3a924a0e710a64e26fd3ae60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b52a402ed9447c4a84dc757dc4648ca74f38f1f0c82670f0bfd4bb1baa02e6ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "915e12db053eff91ff3fb63a94d92c94e87d33133a12e32c1c1a9677f8b3194e"
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