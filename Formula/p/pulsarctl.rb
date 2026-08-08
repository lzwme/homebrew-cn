class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.10.tar.gz"
  sha256 "f6f3508d1b56a5d4dc34c36b845d70fbd02b74cf25671b98c23777c49d84e881"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93487ade1b2bad54fe228f2527f94207a62fac0bb63cb5dccd800ea939f1d7fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93487ade1b2bad54fe228f2527f94207a62fac0bb63cb5dccd800ea939f1d7fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93487ade1b2bad54fe228f2527f94207a62fac0bb63cb5dccd800ea939f1d7fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f02fed0dc92eba09c9b8104248056e76b4e9ad0e303a05dd1f4d1799e098bc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1e30d1f4506df6546bd24f45a3037490aa5fb8806a3d767d9afb312f1c78780"
    sha256 cellar: :any,                 x86_64_linux:  "8b855af24b056cd7d6139f7f48cb775dbb8ef65e96b3e45a27062be6dbc659ee"
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