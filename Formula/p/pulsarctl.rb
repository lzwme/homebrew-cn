class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.3.1.tar.gz"
  sha256 "3325219196d856fe8b8d12ad7aa218bea0b5d613f86c54ac853112da40ad6620"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f71abba42db478255d7815e649baf6c708e725aa460170bd159f86101b7d424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f71abba42db478255d7815e649baf6c708e725aa460170bd159f86101b7d424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f71abba42db478255d7815e649baf6c708e725aa460170bd159f86101b7d424"
    sha256 cellar: :any_skip_relocation, sonoma:        "c45e86f3f0c8c65487833c47f163b0b2c6662a464a775042de7c3722f1d7e210"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b123a9ee6e676c017cb42444f107309ca2439cb37946d62d0051e3c9a229c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef96e38263824b2de0cdde1c91988904e49fee6efdb3cbbf780316d378a7138"
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