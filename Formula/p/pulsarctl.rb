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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89a7c1cf30aafa91f45d256a41eed6c2eec92092c01c718e5f21d4fcdbeea67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a89a7c1cf30aafa91f45d256a41eed6c2eec92092c01c718e5f21d4fcdbeea67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a89a7c1cf30aafa91f45d256a41eed6c2eec92092c01c718e5f21d4fcdbeea67"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fc982b660f33391858d9c802147b182048394eb2cab66316d96b3fdf9be4221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08aaeaa538e0f9bba902db96bc67df3425351cd22e0803b6c0c0e80913f59f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f786253e9c88dfb44474c450de7d6701afe5ec3b4325d05dcc336134e4398b9"
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