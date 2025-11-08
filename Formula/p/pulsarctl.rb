class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.6.tar.gz"
  sha256 "b37af261b72ef6add9701ff711a28f8ab8d507da176273ded939e00be8a780a4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f586a45ea5ed2dd50817c204e5c6fea3df4e8a5252b9fe59b8faadfb510222b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b92018cfe03c4c23848113ac0239cbb004c6bdc9ea469ce6fbee2bb0ae05ab2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11aec8ca632fd60171451b59c157762a39cc9676730265921d292454a69b743a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f3648c7969a9a283f6af8e12328fb0b592c1b05e9cc0ada27d88fa9e6c81b37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec16e945387b153e73b9b9f7e44bab4cb21ec244e149ea7bb3f2938d1fd7685b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8823d9e36d8757dcd675d84f99ea0d6693b0c3ff43d9c260ca135f8d4566680"
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