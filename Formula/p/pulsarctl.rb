class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.12.tar.gz"
  sha256 "491b92544b4c676361b78e170bc32ddf39a01ea218ce4921353449b55d232d88"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4d14c95392137bdd94fb18da33cf976fcbd1068544ce0b466e6c719c6e82694"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4d14c95392137bdd94fb18da33cf976fcbd1068544ce0b466e6c719c6e82694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4d14c95392137bdd94fb18da33cf976fcbd1068544ce0b466e6c719c6e82694"
    sha256 cellar: :any_skip_relocation, sonoma:        "54cfa993f64f7b71fabbe18ff9b60dde29dd4c82633d16ec8d388dc0fad2ea50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30d5dcd15485eca661610a3a659bd29ab39bb563a9326895008cf9a634e82c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e892fa171046398b51b6f8f34d10782126f733de2050947e37d55cfcbafd49ae"
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