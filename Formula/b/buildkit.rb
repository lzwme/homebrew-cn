class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.12.4",
      revision: "833949d0f7908608b00ab6b93b8f92bdb147fcca"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a043d8f23c7942328bd814e8461be1aaa5f99304337b55314947e39bc3a9bfce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f22804f2f47578e821607ed6446d8bd3d1bca5f0fbb8409bf927432ffe332449"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b24f866a16f36b4b7e2332d15af84c096884fd6c7a929521755915ef25b93e1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7de2fc27fefaa02efa8c224a9645f6653fbc2299b2cdcb55010c2ed1802183a6"
    sha256 cellar: :any_skip_relocation, ventura:        "e05704d67bc1698c1cbef539112c00bb714176a64e6b1ffe3b18ef6c3f0d2a29"
    sha256 cellar: :any_skip_relocation, monterey:       "cab6b5cae36fada4d1b0586fd7bca067dbbeb5e836ef71746307429146fffa2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "732e9292303e72e3af5a115d7577dbaea12f6635fb8be8952cfaa28e26766862"
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

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end