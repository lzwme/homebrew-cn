class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.32.3.tar.gz"
  sha256 "7701317f5765c719b7a2dfa5ed1d83ba3916e3484695e88f601852a55755bb2c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3dcea49b9483cb4cdc7a10e0d447968e0c7cd7e7b3449b384cb26bf27fce4d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b22659c4630e50a3f1891842222d6138e1f8cac0e86db851a103d80dd35900b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a68e5b556610925aadd28479293b1bcc960355734e2f1dd7f9f0e2cd8691ea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2730228e0026dd2ca3742de2b93f9e390f642ef5be803b1b1d591b0d12c1c656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49e9825db518edd34212dfdb48517ec791390a2da075ecfe444322cabffe1440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4f21c085cb9f486d8c1d5a505f4b58d8d188c3d15e40075f517ac24a8da807"
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