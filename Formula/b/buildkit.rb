class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://ghfast.top/https://github.com/moby/buildkit/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "1e7a0c031c038a7399eacf52655c3511ce5f0d83f1d7c821fb44821387a76e2c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "492e0bc2ab81e09910a2f7f8545be1d15c9679266d901f5b23d550a3ae1c4ba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "492e0bc2ab81e09910a2f7f8545be1d15c9679266d901f5b23d550a3ae1c4ba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "492e0bc2ab81e09910a2f7f8545be1d15c9679266d901f5b23d550a3ae1c4ba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "68dfcb64ef88289c777b1eec6214e3285a69dc115cc4f96db0387d1224e7e863"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "463c6bf7d03715a14f7166347409ae945a19d090f9a77fac1fc3ff08550c77a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f9fcb73ecf291b0a0adbd0451c4a3f130cd1011b705b6711ce2e74e2cced235"
  end

  depends_on "go" => :build

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -s -w
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