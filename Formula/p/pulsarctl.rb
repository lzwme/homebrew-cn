class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.0.8.tar.gz"
  sha256 "81d5b2fc6e1485db7f6117d773150205d476809c2e81d96e31733a669ad34531"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2ff05743602740e39ed1fc69677ffb290a903de65ee446bdde76911104eb8fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ff05743602740e39ed1fc69677ffb290a903de65ee446bdde76911104eb8fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ff05743602740e39ed1fc69677ffb290a903de65ee446bdde76911104eb8fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "94558efb639661b1ee9c95c39d4cef9abf057dbdf19563810d2666d4afee1c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ce155b074732f1d205bb5e150b8b5c48cec218c14c8a885739564957222de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f711330685fcf32c699622ec82703b1244446355b53c9be1a7609ea96b2d8686"
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