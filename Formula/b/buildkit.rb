class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.25.2",
      revision: "dcc0fe5e96ae78919b30057d0804c52f13a2eb7e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca9304391e0f14591f2cb8af92ed1fc6540cb8d41d8a3ea99d7ba7e6bea89cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ca9304391e0f14591f2cb8af92ed1fc6540cb8d41d8a3ea99d7ba7e6bea89cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ca9304391e0f14591f2cb8af92ed1fc6540cb8d41d8a3ea99d7ba7e6bea89cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c55b46093568826bae40e6b853128b7719c354268b151708be606027dbf8ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6e04641879cabbe6f21645629fec70c42be3aa2ffb85808799486a16c32789b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eed4ccd1ebbe52ef3181c2fabba19791d3013cbfba4d9f29ef0c7af3cb5bb98"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end