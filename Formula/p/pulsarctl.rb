class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.6.3.tar.gz"
  sha256 "9b520f9c70b7411b488ba69d86a8d3f48003500ebac67d975bb6603ab8ea6761"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec615315c8fd90e90bfe303aeed8760c0ac53c97d70404df74fe962504d6560a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f3a8f1e31d7cc3e8396fa6255d3058fa2acbdb9047539944a83f0896ec56c26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "637e57c84900b5b2d1c47ebf709459f5896b76970d92139ac60ef2c4aedd0b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "475918c08740a33db3db5a3011421203c959e75e91f00ca6c07783022d7795b6"
    sha256 cellar: :any_skip_relocation, ventura:       "d9a6e9a3aa8e323a4804e5d0c481b1329be350e4e052a5479212e59ec3295cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5c63d7ec957313630d4fcfe7e46b80826190ba8e3f60aeb020d8e67092dc5c"
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