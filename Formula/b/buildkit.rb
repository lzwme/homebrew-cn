class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.20.0",
      revision: "121ecd5b9083b8eef32183cd404dd13e15b4a3df"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db527ce34102464a805ea6c5e0d24689dea95b802ba302e8174dcbd3848da20d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db527ce34102464a805ea6c5e0d24689dea95b802ba302e8174dcbd3848da20d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db527ce34102464a805ea6c5e0d24689dea95b802ba302e8174dcbd3848da20d"
    sha256 cellar: :any_skip_relocation, sonoma:        "183934ba5fcc9130b5e809c1c4f8a748bed17831a8ce7904e41951503b2bb6f2"
    sha256 cellar: :any_skip_relocation, ventura:       "183934ba5fcc9130b5e809c1c4f8a748bed17831a8ce7904e41951503b2bb6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba1ee9232688d5d03e9db4808cdf0b20664b2f6ceaf2e55d9953dbb44eb2e63"
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