class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.13.tar.gz"
  sha256 "34d2151785d0c958a8feab0efc8bb2d22f6de63ed07acc6d2651b2f87ef487c6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fab930cc9189a49869bf245bbae59cb831773b5e71267cd94601e772f025892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fab930cc9189a49869bf245bbae59cb831773b5e71267cd94601e772f025892"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fab930cc9189a49869bf245bbae59cb831773b5e71267cd94601e772f025892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b8fed32437df853c9a97ed3f337b24cda7bf485fa244a5d88fe7743332f4bb7"
    sha256 cellar: :any,                 x86_64_linux:  "fc050028e6b1c48c5f2c81f1894098fd2364d0acbaec86c3c21dc270e2eea48d"
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