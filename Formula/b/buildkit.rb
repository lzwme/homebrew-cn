class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://ghfast.top/https://github.com/moby/buildkit/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "d000939ab93c32eab5a6d7c7a200bf4d42b1972a0e0dec5d5ebbe60c02667183"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ae7af33738dcde1fc617d211cbac5dab01b1f9113cc8f6a01a0b9e941f08575"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ae7af33738dcde1fc617d211cbac5dab01b1f9113cc8f6a01a0b9e941f08575"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ae7af33738dcde1fc617d211cbac5dab01b1f9113cc8f6a01a0b9e941f08575"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b31defabcea6dc353eda34dfbb10d7d83a2cda8feaeb186f2a70a31dbdccc74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee6afb0f7d6ca7499326b1c2f193594c13bcaa4f47dab1fb2d28395402cf237d"
    sha256 cellar: :any,                 x86_64_linux:  "6559b13c5193c132dd6ad8fedf3797b56c99d16d6b4f53cf9e81b7b3f64cbc90"
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