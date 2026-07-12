class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.7.tar.gz"
  sha256 "8bfb97ad889e2bbc0f49b3292fa79b65b752e395ae40d6e4959c53d122c482fa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d52af2f7c17f3a83e8d359db51e109288a38cb2a0ecdb23b3c2cab1f84b8c280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d52af2f7c17f3a83e8d359db51e109288a38cb2a0ecdb23b3c2cab1f84b8c280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d52af2f7c17f3a83e8d359db51e109288a38cb2a0ecdb23b3c2cab1f84b8c280"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6177ead0be9627c53da687b1acaccc9313846f839d5bc10c8b81ad2fb6b80a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1576f29e2eb2773db87869ad062b501ed08816444387c41981b9efb5f27324e"
    sha256 cellar: :any,                 x86_64_linux:  "2d4aacf40048204cb1685bf00c9f8ab42b18041ded5975131326fef03117f9fa"
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