class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.13.tar.gz"
  sha256 "73bf24cf90f399d3734df8166624e7aebe3064af9f8467b5771affc807960390"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4451647443199d241404f2c78c9dde09b4aaae42411861d556083a0fd38dea28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4451647443199d241404f2c78c9dde09b4aaae42411861d556083a0fd38dea28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4451647443199d241404f2c78c9dde09b4aaae42411861d556083a0fd38dea28"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c27d58b0856f99767073c57045d03041d7c1869438818d3f52ced61c818efaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f79a5b222ed9c7bc14bfcc44a4c3a8a004467aed412af3ca2cb1822c07f98ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "348aeebb5f2a9e363e1d9bf8d13152b4c8495a88e71d2a4e7c22023fe3b48533"
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