class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.28.6.tar.gz"
  sha256 "294e8f3d0b8bfa2ada25ddbc7cb5cdb479d0293459bbc2b60b28fb76795108b8"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce57bf4967ef6c2ff06c2f973c35b239461ddedac926c0eccea5de16e4396abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f34be6e46590c0ac099bf2bc8acdf25e9b029ef6f88b48137a8cf11f2030dbe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdce71db0946cbaec569759cf649997924ce985e134ac359f203afda1fe1f1c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a297975e395a6f18295d37825d0a0ec672a1260db1fb250e457d01efd4333cdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b62955446ec62f468fff3f26938e9c947e755fab9c6bd5a493a86b4c597dc739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "575c1ffb5f7599b14f6b5421dfdff6d29766903c5fc7c740555c5a4d9b2d67c8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end