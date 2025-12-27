class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.11.tar.gz"
  sha256 "445836cbb3786af2f04bb020d606dc66c7b0aa79fe876071e6c36bf0cdc064af"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1bffe6aacaf35d6011b5c36695f4605d685a162b6944ab7e3415f7e68e20661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1bffe6aacaf35d6011b5c36695f4605d685a162b6944ab7e3415f7e68e20661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1bffe6aacaf35d6011b5c36695f4605d685a162b6944ab7e3415f7e68e20661"
    sha256 cellar: :any_skip_relocation, sonoma:        "09cb2b5f4b5b935ae0edceb8f9257660635ac25ae1147d73aae0b59715da3784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f9c818b233c057706a0e18821c6077dbc578d3c1647f5633b4f7f7f69f5c54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38781c110e3113b8f201484d5b8bd1b37ce834042868ce81722837dfa0292427"
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