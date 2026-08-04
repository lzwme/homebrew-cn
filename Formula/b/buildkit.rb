class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://ghfast.top/https://github.com/moby/buildkit/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "23370825c523e11655690818c7e9b571f9b7b498383b49f592791b64977265bb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "482628a67dc3642a05df65044532ef894b7479c14106a90a13a5004807d15afa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "482628a67dc3642a05df65044532ef894b7479c14106a90a13a5004807d15afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "482628a67dc3642a05df65044532ef894b7479c14106a90a13a5004807d15afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "25c0e6bb6dff3703550b8be67f0f8c3e8a67258f009457519670c8d6fc86c606"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "950790232bc32dd097b5c23f66dba0de76e71242cb6209a6619e65d82b5eb9a8"
    sha256 cellar: :any,                 x86_64_linux:  "382612dfbb6d620a0b44a95596ff695421f0c6147e521bf76c86d8f3ff71e075"
  end

  depends_on "go" => :build

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