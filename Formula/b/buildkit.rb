class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.15.0",
      revision: "e83d79a51fb49aeb921d8a2348ae14a58701c98c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7548d4467e10ea2978d96502a1b70699a00dacd3ac3d7315af6b21edca89eb2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27f5cd905f4108b5f1e3612572c707e6f2f8c9aa6d52badbcfb0ecd343e0842e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8610b0ee56cf235a2f8b47dc614b3640fd6de15fa354ca0781ae6d286f6ee019"
    sha256 cellar: :any_skip_relocation, sonoma:         "27b3ddfc6cc839e6fb77dab5a98dce729c3c78e0a1fe1d60284b1dcfe0dbd39d"
    sha256 cellar: :any_skip_relocation, ventura:        "2d387aef3cf9769baf6bde3f848abf50262a17f5ab599ae53474efece1c9ddd7"
    sha256 cellar: :any_skip_relocation, monterey:       "ff0ece66b1454e0fc65ab107fa98ffab832296d57b24b1d11f166ae34e561cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f14bf60f078dcf086de08d622f2027c6d06faf4f2a03e85be47e627474ab25f"
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