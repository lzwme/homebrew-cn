class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.26.1",
      revision: "29fc55f96f093a780dc0b6826719db7dce49d2b7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79f8d610a6bac0fbcd73c76fe0136146a72d8265629c5e108958df01c5f3bf8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f8d610a6bac0fbcd73c76fe0136146a72d8265629c5e108958df01c5f3bf8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79f8d610a6bac0fbcd73c76fe0136146a72d8265629c5e108958df01c5f3bf8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dabc75a022090f07e17ea6ddfff7bcf483b99232d0767338111cbc39e728c96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d452ff27c21e9600ff6954b7611615414ed3f016e22a52ff096c0fe23c14de8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d08a2301d92ae538293a6b188a92bd1b1ad2df42e34db2af9e0815458b7c05"
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