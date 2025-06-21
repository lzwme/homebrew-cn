class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.23.1",
      revision: "0a230574721405f79ff7361596ec55045f3685bc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1bbdbc9c43bbd0c357d1ea4a3be4527479fb1242520d8950937e72ac2bdf3d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1bbdbc9c43bbd0c357d1ea4a3be4527479fb1242520d8950937e72ac2bdf3d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1bbdbc9c43bbd0c357d1ea4a3be4527479fb1242520d8950937e72ac2bdf3d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b05c9321b291170b7d51cefa4f519c73178f2a7f2b6f5a34f5a9ef8dc5c62097"
    sha256 cellar: :any_skip_relocation, ventura:       "b05c9321b291170b7d51cefa4f519c73178f2a7f2b6f5a34f5a9ef8dc5c62097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c38618ef4ad626c5962ca041e81c3e1d80e94acb354b74b1888280286d1fb44"
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