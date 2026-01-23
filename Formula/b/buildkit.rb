class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.27.0",
      revision: "2bcd66daa720bd45da2a43db59cd3e8ddf3f39ae"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d80910f4576fc9c8e26868c85f65f025e8bd322078dec6710658a1b33052494"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d80910f4576fc9c8e26868c85f65f025e8bd322078dec6710658a1b33052494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d80910f4576fc9c8e26868c85f65f025e8bd322078dec6710658a1b33052494"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c44860914a93fc256b46b760a7b2b7857867d0e049aff0d2ca59c35eca18867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0236fe50e7936b0f815d6e36e4b91e4408dfb565a58c9026ca707b33bd492a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade55602096382403b39c878f814e01132228dac0ae16e679bde6552820c4d1c"
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