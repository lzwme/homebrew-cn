class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.12.0",
      revision: "18fc875d9bfd6e065cd8211abc639434ba65aa56"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa80111b2b93379169589ff5f253dade946594d68f77bc6d8e5f0b081e7fa12e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa80111b2b93379169589ff5f253dade946594d68f77bc6d8e5f0b081e7fa12e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa80111b2b93379169589ff5f253dade946594d68f77bc6d8e5f0b081e7fa12e"
    sha256 cellar: :any_skip_relocation, ventura:        "198c4f72fdf24237752ad214f0d203e2a4850db180206ab2b47d77ce61219bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "198c4f72fdf24237752ad214f0d203e2a4850db180206ab2b47d77ce61219bbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "198c4f72fdf24237752ad214f0d203e2a4850db180206ab2b47d77ce61219bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "398f867175a64c45392cdff0ede010b7a87ef6bfd34efe500f434e66de6c9f50"
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

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end