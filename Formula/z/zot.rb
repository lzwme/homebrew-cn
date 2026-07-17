class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.88.tar.gz"
  sha256 "717765b110c16d0ce16657fd75bf75efe0688dbcf985615bd86fc822acfa9202"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc69fdf0d4412c62ed06b6a2d8575fa7db88e443dd6ccb0ccb7f2c8c4274d0a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc69fdf0d4412c62ed06b6a2d8575fa7db88e443dd6ccb0ccb7f2c8c4274d0a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc69fdf0d4412c62ed06b6a2d8575fa7db88e443dd6ccb0ccb7f2c8c4274d0a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad64d004113f4a2c06f72cf9862d4cba9c651fca4a6c21fc9740ec6faf5c9e0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00a80a02672485d79ac251bf9c47b53da8b2b5275872ce7314c3e54ffbe1759c"
    sha256 cellar: :any,                 x86_64_linux:  "52e8d198a39db6f023680feff4f917a61f313521b02e55b2229fb6dc91228bdb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end