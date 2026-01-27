class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.15.tar.gz"
  sha256 "a049ad8b44fe034d268e8c2376d7d6ec94296de0bd97657156de145d2cabdd21"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b63d828818b25f0bfaf5d9780444e70909d4eeb18f7289c721027bb12467ea9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b63d828818b25f0bfaf5d9780444e70909d4eeb18f7289c721027bb12467ea9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b63d828818b25f0bfaf5d9780444e70909d4eeb18f7289c721027bb12467ea9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e1e9be41cb227eed13aeb4ea3b8bc5224bbbfb240dbcdf6d47bb50642aea3ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ce8dbfa8d9f172149978976412793accdccd05ec20b3e0d2013a51ed937699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efea18555a4bed13edec898dba7620c697ea81a5f161a5ca74dde65778b5cd5c"
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