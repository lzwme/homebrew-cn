class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.5.5.tar.gz"
  sha256 "1afe190c4cdbeaea680e6c3e6b183dcb1a803d362f6bfd292710c5dc82b991d9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec34d84c896eca547f6d4d7bf65c6b18743807ae143b2e8c3c3685718dfe3b6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20dd8c80bc2501b0354a6272d0dfbac063ffb7a98559f1edca3bc2737ad17005"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe1fef885ab77fdcde938cb160d97d7db3abd07b29fd9a3e936c6ab8530b6e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7a4afe9940e3960d1efb1c4785581149aa63887de7f3eb325defc8d96a26f1c"
    sha256 cellar: :any_skip_relocation, ventura:       "600672285d2924ec71382932ff607a18c43ae53dcdfec49fa256dc44c65d0fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b37976b786faabfc00908ec92e66c47a2bf7017f8fe8db6f9887bec126e5652c"
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