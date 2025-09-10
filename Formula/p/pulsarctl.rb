class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.6.4.tar.gz"
  sha256 "3090100f1dc94583f37e9896a86406c8580c3e4a43ed37c9e489cf683adefd64"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74ba00356d08a293e7e4ddcbe113967dc2f7f925182c8be229cb54711e8909b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "393ff54ea1a55bb2fa54285d2485f4578179469236a4327bf3e9946bfe14e6e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfc76818cd571de9489a313e9bccd663700aeba2ade0218e0124f834e09f3b5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "62bdb4f7692514c137a2c7eac4dfbc25d48c53464efd63c8948d657508443179"
    sha256 cellar: :any_skip_relocation, ventura:       "2204f9d38d669e5c5d30e5bfd815490c7e139e871a4a79640e20e04476638eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ab6c9b5fe09bfe17c59259938276b7bddf94c69454c153b805aba4f2038504"
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