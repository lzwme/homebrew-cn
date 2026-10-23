class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v5.0.0.103.tar.gz"
  sha256 "487fe1d569affc3adef3fa9b21bc12b410758b382b6ecb12c70f9e167360d956"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7852cbb00a9284eda4c31c86d6e67276485721bca8cf287eb7b21db3b09587f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7852cbb00a9284eda4c31c86d6e67276485721bca8cf287eb7b21db3b09587f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7852cbb00a9284eda4c31c86d6e67276485721bca8cf287eb7b21db3b09587f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4af18b0681b8a010646b4feba114ddf4bc0349d34c7e56312c67b723cf015388"
    sha256 cellar: :any,                 x86_64_linux:      "78dcaa32a20cea4732ed5d0ddce1e52658b70bca75b8ec884cdd32b7556f726a"
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