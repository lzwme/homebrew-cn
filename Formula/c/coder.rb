class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.37.8.tar.gz"
  sha256 "76b835dcb59eaa6def6fd1084b5d6672146bcb098279570f4b28bae60e7d57b7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e378c4f5de758c6c0d48790cc5b0349c1516a72bef25d7e8f4f561d16fce5bbb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "110062ee3c63c7f8add876c4bc8ae3ff1360d72ba7e53ebb133cb3d9ede78f3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69e8d7d6fe32a252921aeb3f184c02138a35940f7f57eac17a3daf96ba992503"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff9a790bd741eff221790f5c70662134b56f5219b6dec72f354e6b2d6706d23d"
    sha256 cellar: :any,                 x86_64_linux:      "73dae464f1f252922c2a39dffd916bfe7fe94c948f808f134e85f8525f5aae9e"
  end

  # TODO: unpin go@1.26 when coder supports go 1.27
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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