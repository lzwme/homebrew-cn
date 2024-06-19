class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.14.1",
      revision: "eb864a84592468ee9b434326cb7efd66f58555af"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "830a17d3a82f77d33b47ecafd70e484f42d44fbdfd9856f9b33fe729e2677d0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "245cc3e84ca0e9d6f8397c8f1f5ea2cbc2c0c54bc53194356617712fc5f9a515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9d2a4ee4cfd818fd9c95dc109ff979a202efa3c59466c0bff7f9c4e324fbf62"
    sha256 cellar: :any_skip_relocation, sonoma:         "a31a9b5c1bdc7606fcdca355983d960f6d0cb66201633605e104eaabb36fe2d7"
    sha256 cellar: :any_skip_relocation, ventura:        "ec17808f120b1e2730c6aba52c6e9fc2c977c05c281c994dd3bfd647854ce51e"
    sha256 cellar: :any_skip_relocation, monterey:       "a65e266204148b6815fe6c2cc0ba0c11f3209410963ece50823ef97e61565f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "072a22eabf064b0c4055e99bec73b565c77660c4c46554d8d1d83a288edec405"
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