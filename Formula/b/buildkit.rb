class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.23.0",
      revision: "cc8ff80e5733eb0a0347176009232d6e40752f7f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2481573f0d865f13f033c775255eb69e35be093f2557d40b2f593a30a2c34ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2481573f0d865f13f033c775255eb69e35be093f2557d40b2f593a30a2c34ee4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2481573f0d865f13f033c775255eb69e35be093f2557d40b2f593a30a2c34ee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d5710634c47ed828391a2788357e01fbb3348a30b7419ef8846d36c86391b2c"
    sha256 cellar: :any_skip_relocation, ventura:       "9d5710634c47ed828391a2788357e01fbb3348a30b7419ef8846d36c86391b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d957ceae55fc9fd8eee585e425332e19211fba81fde633578d25ae3ce529a24"
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