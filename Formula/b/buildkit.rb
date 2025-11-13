class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.26.0",
      revision: "a8e548fbbd38729bf9bf1a3722edc21fe3383f97"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e5532d3e9e5c62758a1b7fa245a01bc0ab238341ee2ece18e3cfb47813a37a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e5532d3e9e5c62758a1b7fa245a01bc0ab238341ee2ece18e3cfb47813a37a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e5532d3e9e5c62758a1b7fa245a01bc0ab238341ee2ece18e3cfb47813a37a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "41edbf746c742428d5c9f75076a500827ff23a5eb9a1da097f0a2a5a69ada26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "798f2392c131f452d50a39b446503a574de7f46cc9c997333f222a49056be8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18827575dcf9e28e8dbf307e89d52efed62502b578a5249d229cb55a29c26bf7"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end