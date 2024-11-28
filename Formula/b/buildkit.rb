class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https:github.commobybuildkit"
  url "https:github.commobybuildkit.git",
      tag:      "v0.18.0",
      revision: "95d190ef4f18b57c717eaad703b67cb2be781ebb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "648d9384d914ccc06c889381167c8095624965da76c9c8162e9417fe9faee5e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648d9384d914ccc06c889381167c8095624965da76c9c8162e9417fe9faee5e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "648d9384d914ccc06c889381167c8095624965da76c9c8162e9417fe9faee5e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8566e7820cebfa3f0a8b69c901888b0ee9d54e80c9867b7ffb44bc6f7dae4d1b"
    sha256 cellar: :any_skip_relocation, ventura:       "8566e7820cebfa3f0a8b69c901888b0ee9d54e80c9867b7ffb44bc6f7dae4d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d794f873f7a2169629f92d56077a3189bcb62831f1eb241a40b248c91cbb583"
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