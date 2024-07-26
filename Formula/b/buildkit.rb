class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.15.1",
      revision: "979542e90f2cb38077c808e0867d8d2c16ed10b8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f8a5215a4f91e513c24367259f1e94c71353d13241c54ef7245606f5f641768"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31997192ce6b31cbe6eade2542da04ec66057280f3db7d3346f0c7bde05de408"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03913a0fa2d0b1fc94d20bc822b5d4600e9c93730bc51c33b8c796a337fde8d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac2b0c5a753ebdccefa3ae830f5ee3f5b08c147529bb1108b2a2a1348c78e98e"
    sha256 cellar: :any_skip_relocation, ventura:        "c863b09c802b54197f24aa73402c504c7e038b2942fda7f1508d5bb954d03bab"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b4eb143ec7d6b71862fcfa4e6f582f34afe7f688a9e4fed88c0616d4c2e3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76ed24df4e7800c319fb2640282587ebb06ea9bda2d2b7dda6fe73a1dd4fefb"
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