class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://ghfast.top/https://github.com/moby/buildkit/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "43a9144c2bb234683e798af23af64f5bc6499362f1b389eaf7c33573d9f59b80"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60869ac4822f27437bb52442a5d0fe5817f584e4b2a279ef73b506522ca6f40f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60869ac4822f27437bb52442a5d0fe5817f584e4b2a279ef73b506522ca6f40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60869ac4822f27437bb52442a5d0fe5817f584e4b2a279ef73b506522ca6f40f"
    sha256 cellar: :any_skip_relocation, sonoma:        "893289be6cbc677b2bfa5b2426c8312c70c499e193da1b34ef3728b2cf156042"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19522ddbe8c7d89d78e322bcda325ec18523b0034fb9ecf1f516ad534d5dd18d"
    sha256 cellar: :any,                 x86_64_linux:  "a89d81fe638dc06a605c35a1c3d27cd5945ce955a1ad6dd08b9bc39da094026b"
  end

  depends_on "go" => :build

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install buildkitd
      EOS
    end
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end