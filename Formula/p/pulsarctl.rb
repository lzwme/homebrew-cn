class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.0.3.tar.gz"
  sha256 "ce61674e3ffff1f3090b41d35411f195615fe5161273b05990027387bbc98a5c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21f84a6140d90d58985be1f41872bcad7be466d31edcbce660e9c97b40668bf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21f84a6140d90d58985be1f41872bcad7be466d31edcbce660e9c97b40668bf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21f84a6140d90d58985be1f41872bcad7be466d31edcbce660e9c97b40668bf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "194259c3bc9bf5f3e44142a09d814b68991a41ff7c2c388d200816510994b169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25e7e014d2a86c056395dc1a09f84cf39e8ec832f095bfd5e9eb4f6f7d7d3aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22fea048750b42ef5fcac882b6955a57bf10c4123793c90e8ae801c4da25c911"
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