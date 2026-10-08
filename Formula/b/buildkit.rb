class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://ghfast.top/https://github.com/moby/buildkit/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "b51e3a6bb7e0a0381adef47bffb8527817409f477fc5d26054517af29a11ff65"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "855c4d561cdf4d11da4b392b1bf39681392f333cb1a5621c8720ec4ac5d73ce5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "855c4d561cdf4d11da4b392b1bf39681392f333cb1a5621c8720ec4ac5d73ce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "855c4d561cdf4d11da4b392b1bf39681392f333cb1a5621c8720ec4ac5d73ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3cb2a0fa8d73c5185170ae1dc4034d6a78be21e183ec8d6b398aacdf20d75f8c"
    sha256 cellar: :any,                 x86_64_linux:      "5cc08808aa6a50b29d0af4114bd241c90d46f9a80a5f29775312add3910cdba6"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install buildkitd
      EOS
    end
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end