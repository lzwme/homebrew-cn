class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.15.tar.gz"
  sha256 "5b05c212bef0f9074b60b5a464bfe61189c2b7ff0216e40c0e2263d344877ca9"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "942a5821f2d21f33ccece43d21f308641966d56b66fc535e4302aab4212bd27f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "942a5821f2d21f33ccece43d21f308641966d56b66fc535e4302aab4212bd27f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "942a5821f2d21f33ccece43d21f308641966d56b66fc535e4302aab4212bd27f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a8d3a54fdd622803253d529cde310205c37c4e1596572b5d1ac5ab8b1d8f5dd"
    sha256 cellar: :any,                 x86_64_linux:      "8e97bd8823b9cb97c1a2cf1ee612c995021fa4c30457eb28b51377ed9de2e4cd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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