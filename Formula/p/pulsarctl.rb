class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.5.4.tar.gz"
  sha256 "edc57883da65b8606a4e12e2cd00d1160f2c2f8f714ec101758adacc6b53f9c3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad3d3aa23a3c0b854f7a0586fae98fa7b638e3e859d561f4118476aefab6066d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e32639199a8eaa25e17b69a6c821eec58fc73911e71a49549d50c5c96208f450"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05389fe4e9be9bea650e2d8572328b6e3b6c12a6b50fd66e2a8af7a1813a3d67"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0da7674e55ebc8fe6f5d50d9c439f3cc62416223c7a1784aa8be8bbb3e02a9d"
    sha256 cellar: :any_skip_relocation, ventura:       "cbbe3d7a4a78c223612c0503547e022b6b27131aa0226b45c9cbe18eb0a4fe91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989bd0e02500fd6dc27b81513b608068afae1e71aedf9bc2598b6d7db75a8a7d"
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