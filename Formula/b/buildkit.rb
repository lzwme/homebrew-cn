class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.17.2",
      revision: "a3d734228b860a215f8a336e3983d35cbfaf08d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fe5140d986529aa394b0c223cedc82fe636dec8e3c76d24515856e8668cf511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fe5140d986529aa394b0c223cedc82fe636dec8e3c76d24515856e8668cf511"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fe5140d986529aa394b0c223cedc82fe636dec8e3c76d24515856e8668cf511"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e8531fef400d8f753ceb9fec0cff0f7863cc8632bae925f1612320fde91824"
    sha256 cellar: :any_skip_relocation, ventura:       "03e8531fef400d8f753ceb9fec0cff0f7863cc8632bae925f1612320fde91824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd60d61e9dc004b185d8ca5bfc89fda0848ca8d8adb53c730e8d06a7708896fa"
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