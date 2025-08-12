class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.6.1.tar.gz"
  sha256 "cdcb4483a5d82e672d72ff58c8821854255a3555d9f39f8c86163025112f22bc"
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
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a88c608698e321f3c9acdc8bd49e80d4d1d3b4fe588619289d345f0fc46f11c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f61787dad7ced5218932f6c4eb6c2ad5ce7d37e0083d9a30dcb72bd7cbc3d29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f2291986eb933568d7384e6ae2cb71632d53e1c8fd5899d1601b6ec092521de"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cc01848bb7a425d84008f654d0ed57111826ebc59e8033125bd004f515502cc"
    sha256 cellar: :any_skip_relocation, ventura:       "df6983cc54df7ba93731d3048469a42ba14b5fc74f86a37b3cf9a61152192be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0557a144b995f7ecbb09e6fa88d8e72d863bb700db8ff6a0de38d6c8cc76e54f"
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

    # Install shell completions
    generate_completions_from_executable(bin/"pulsarctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulsarctl --version")
    assert_match "connection refused", shell_output("#{bin}/pulsarctl clusters list 2>&1", 1)
  end
end