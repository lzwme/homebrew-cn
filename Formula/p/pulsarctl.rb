class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.5.tar.gz"
  sha256 "3f6df173e1a61d9f11482180537f47440d49bacfa5a4a4f199e0991f49748b00"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b175a8b4b100de5436e335c529a140356ffb704df3400d843e389f554b73f52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f4ff1a98cca50078a47fcd4dca80a8964826aeef55e17a4850986b9ca4fe161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8966aab3f8792cc9f99732bd33873c9094ad6f2b658c3dedce2ec271cd6acdc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "302bd44f198489a2755e4a7351942f71d2325f184fbfff36563fd9b6a20bf3f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a74fabec0688de655f6a013c855aeaf0e91e2caf60f03512e5438d6c1bf8334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f110f99ea743a921997bf62b7e68de5467fc92c38a63f957cd01106da487c59"
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