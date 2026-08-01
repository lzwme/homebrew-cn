class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.9.tar.gz"
  sha256 "7350094e1ba9c0c9bde606077a88fe63d905e82be3ab754a0ddfa5a0ccc26a4e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91b9d177017902506d50abfdf4fc9407e8dbd96d463f528d3ec1bbf44e9b0131"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b9d177017902506d50abfdf4fc9407e8dbd96d463f528d3ec1bbf44e9b0131"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91b9d177017902506d50abfdf4fc9407e8dbd96d463f528d3ec1bbf44e9b0131"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d5e2963303e5f28c5d9e4e9a45a3659736412ce9fb99b874083a2e38b8c2b59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f62b5341f54e3f22a831fcb33cbf957dd837a5f22c6ffb4ea0bb18574425eef"
    sha256 cellar: :any,                 x86_64_linux:  "c8d2f02f728a9c0973334e2f9d3fcfcadd81e660343c1a1d23899bfc6011607b"
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