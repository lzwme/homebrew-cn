class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.3.2.tar.gz"
  sha256 "ffd8dc4424f60f6638bcb3db41868f8143e39c3fe20c24e47ebf1a17048f7286"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5f6192c78a477a9002b0c91a43ed138e8584e1747f8401818cfe7277a8e576c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5f6192c78a477a9002b0c91a43ed138e8584e1747f8401818cfe7277a8e576c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5f6192c78a477a9002b0c91a43ed138e8584e1747f8401818cfe7277a8e576c"
    sha256 cellar: :any_skip_relocation, sonoma:        "882595fe36149580e3626551818fd42b5b13fb0e886248f02b120501dd21a8d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6065d13870677bb985d4ce888354cdb845877fbd19dfa543f65b80bfb4fd4df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d90ee90ff6baa5b9b95a1c5863902be627e1e518b00dface375e3fe623c1b8"
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