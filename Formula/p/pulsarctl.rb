class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.0.10.tar.gz"
  sha256 "5fe50f3e0ed489e6c34327a62f0b6d74bec7fe1238e05f52e19ee77e5b016c2b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f69bc306f51cc99d75ab325867d4ac204c5ed97706279f528d5c618a7a5f76b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f69bc306f51cc99d75ab325867d4ac204c5ed97706279f528d5c618a7a5f76b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69bc306f51cc99d75ab325867d4ac204c5ed97706279f528d5c618a7a5f76b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "432e895c751b9e8baec686a0440a0d5516ea7942dd2cdc0d5b2234df687ed234"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a30dd0b455069c4c7085da921c979da18734095d6227452224d2f2430daf1a0b"
    sha256 cellar: :any,                 x86_64_linux:  "90ec33ba5c60d7f6180f419301557f10bfdce577528fd7c9046b377b573c8309"
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