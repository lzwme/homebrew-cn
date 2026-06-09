class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.33.7.tar.gz"
  sha256 "5045254653dfa37367695238e84447cbb23600327fef64f1015e8387ce6d52bd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8c788d203fdf1e819c45d4070ce059079375de45ddb0f44fe60208ea21b4b79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "591844e37225f1ca359ead11b7808070682f1fb4b45071be9f89a5cf77e25dc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9613b22674260ee2e7a3727dfd2a6c7de49f04d63484219cf1d1379581b3e617"
    sha256 cellar: :any_skip_relocation, sonoma:        "9737c7def58fb40686307c6ad930609f6beccffbf42d9133b11a08d27447b206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a67d91fb0f35ecc382c0bb8d847a5a4c6ac6547090786d61534d66b7d0bce1b"
    sha256 cellar: :any,                 x86_64_linux:  "e66b1ffa3e64f348b4e24d763e187645a94c6780344d93f6c4ae3a7c712751d9"
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