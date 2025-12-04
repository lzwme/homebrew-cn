class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.9.tar.gz"
  sha256 "060edf15903ec4b765aaea2dfda984dc60029d779bed670074d2dfc821bd28ae"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "669da32011e57351e04129c2e142692dcb54e0cd29d13fe679bc3ab6eddb62be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd45bd5c1e2acf704f1e969e5594fb9f49a43d39e152be4bf3f72bda949b04da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1cb6759288777447b16022f47a0bc81e35661800eb93b5932616204f8889958"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c7af416e5fce9cc78a4e5be91e8dc081d46bc0d6f6017ec53b50942b072ff21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fdecb6adbaad6dd4810c06c5b7798e9bd4221d47ad2186d706109a5da715734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14837b19fbfa63dda1a008d48256f1e2c9232f2a62c5406dae847a579c153310"
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