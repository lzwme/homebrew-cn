class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.17.1",
      revision: "8b1b83ef4947c03062cdcdb40c69989d8fe3fd04"
  license "Apache-2.0"
  head "https:github.commobybuildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da1945e80e8c921b404370d03afc1333b7ab59779ba81c1e4f7b1625e5fecb84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da1945e80e8c921b404370d03afc1333b7ab59779ba81c1e4f7b1625e5fecb84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da1945e80e8c921b404370d03afc1333b7ab59779ba81c1e4f7b1625e5fecb84"
    sha256 cellar: :any_skip_relocation, sonoma:        "f282d148753fe083413e9479e8707b5c6de1d727cc86ccfa15106fe528b27ebd"
    sha256 cellar: :any_skip_relocation, ventura:       "f282d148753fe083413e9479e8707b5c6de1d727cc86ccfa15106fe528b27ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff36aa4878342ff7d7bf8705652e33cac2f707b35e7069cc5a85b309f4a9774"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.commobybuildkitversion.Version=#{version}
      -X github.commobybuildkitversion.Revision=#{revision}
      -X github.commobybuildkitversion.Package=github.commobybuildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin"buildctl"), ".cmdbuildctl"

    doc.install Dir["docs*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}buildctl --addr unix:devnull --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}buildctl --version")
  end
end