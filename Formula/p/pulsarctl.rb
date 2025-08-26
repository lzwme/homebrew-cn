class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.6.2.tar.gz"
  sha256 "aad22a28396eb9e0bc78ba51bb316c04d0d93ef2b9e2f566f89d4104374654cc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3565b7de56789b9400a8477f1be2559d73f6205fca91fcbe5232c00f77e15b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac7ceb4a98e432ed5e5dfaec530bb68d9b07075070c69a57e3de204c3751ce10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3bfaf0c6896c5dc6d53c0390de28b4f5498216f6ee5d20ea947f0a3b03bfd9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9944929c0849fe3bdfcb42e43206bb3cd81a4ffdf3ff3ed42e204172f74d7343"
    sha256 cellar: :any_skip_relocation, ventura:       "dcec0e995ea59ab3f3e55bf19cd5fd2e47882b6c4b92a587a364fe3357fc8d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dc5d06f5bfc13228be73401478da3dc5a1412058693e6bc0e3c844ce6bfb400"
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