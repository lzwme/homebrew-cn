class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.18.tar.gz"
  sha256 "cac201c8b9bc5627803266c7f07b75ee5c9fa645dea83548f6572e0b80d6e620"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ad6e8569b1b13271b26efe54ca6bbada099bed5f4081c10ea83d53e1dc68f63"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ad6e8569b1b13271b26efe54ca6bbada099bed5f4081c10ea83d53e1dc68f63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ad6e8569b1b13271b26efe54ca6bbada099bed5f4081c10ea83d53e1dc68f63"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d7514aa976fe5ed176a74e6ad5177319a1fa31db67fc453e2670ec4343fd4d4b"
    sha256 cellar: :any,                 x86_64_linux:      "3ef54f735f94ac0dab32ce0255032e78182bc24ec00c4e31fb04f3ba3425a479"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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