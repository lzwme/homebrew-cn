class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.18.2",
      revision: "e4da654b1251f91e914fab18eba33743aefd7080"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc56f32ea1c411554c1217555f018fe74371793cdaec532c695a3be3ce07df0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc56f32ea1c411554c1217555f018fe74371793cdaec532c695a3be3ce07df0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bc56f32ea1c411554c1217555f018fe74371793cdaec532c695a3be3ce07df0"
    sha256 cellar: :any_skip_relocation, sonoma:        "871bec9ec499e4ad2e6ef84e640911423e304c5a12b7bb2b63be00e6b04bbb22"
    sha256 cellar: :any_skip_relocation, ventura:       "871bec9ec499e4ad2e6ef84e640911423e304c5a12b7bb2b63be00e6b04bbb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68247307c1610dcade99491c776b7da44c622ca9a20b58c6c81249e23d3ffd90"
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