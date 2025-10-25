class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.4.tar.gz"
  sha256 "930067d3ec530f9bd3808e8a02d9a5b45a5beb89251d7e7b237264f3cbdf7c5e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56a749b1bc944ca8fe807a5ae01235e99444e153dfd6d267f0e762e1b886e6dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c00c266f56836cbb06c13cbe24e6cf8c437c41669f1bf039141ab756d6016216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a4163929091901fcadf549f34fe8931383753f981b7779661b03d6cb9cafc18"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a4c05473d5c3f3cc162182a2aee0929f1ec15310a5fdf2384313a6cc945d70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "517362a73140c9631dea342faaeed0825074175b550485675552508153fda2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93855cab364438a2a63f84f68f5be15a156e1b66aca7da0c7d4d29dac4cf0c88"
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