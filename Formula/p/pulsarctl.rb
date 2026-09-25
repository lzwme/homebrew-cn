class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.17.tar.gz"
  sha256 "543a9939d27da199e1cde220c9c9f34411121d9487e48867fde417e3c3fe6364"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba75b412aee167023ef387efb09730d19ac14eefc6fe4d4355d6c73ab5728e3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba75b412aee167023ef387efb09730d19ac14eefc6fe4d4355d6c73ab5728e3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba75b412aee167023ef387efb09730d19ac14eefc6fe4d4355d6c73ab5728e3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "effcf7f9c11a47a63bea7b31e7cd868d6e0f945bab7f7882b2f0987dafb87286"
    sha256 cellar: :any,                 x86_64_linux:      "e105bb484f8f71c07806a8cca92b105b9c639788d56f8a3d20de0a8c516c0b32"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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