class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.17.0",
      revision: "fd61877fa73693dcd4ef64c538f894ec216409a3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4560acf9159d68d8ca6fd5a4a7a160694e0ec02ce92a3a10fec319eb7a7fc701"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4560acf9159d68d8ca6fd5a4a7a160694e0ec02ce92a3a10fec319eb7a7fc701"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4560acf9159d68d8ca6fd5a4a7a160694e0ec02ce92a3a10fec319eb7a7fc701"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7033adea446116748848df4d76c1e89987e24e5e07355e8b42bcb704d8226e6"
    sha256 cellar: :any_skip_relocation, ventura:       "c7033adea446116748848df4d76c1e89987e24e5e07355e8b42bcb704d8226e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664b2e01ff8f248bd098479096a9fdfe1d65ff265d19881c98d1b5e02c4251a6"
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