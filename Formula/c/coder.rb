class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.35.3.tar.gz"
  sha256 "68c5ece7d0242ed6faaa2d5004811685c5854cb5ac4a9e16848de16cfbdb8365"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6f0cdc16dd024c58b734cc3750cc1df1dd5671430ece70d46c5b7ec469b61c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc29d4db7c7dbf996d0b6f8ee86a52b67c5d5131158dcb09a65fa712f5cbb774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbc9744c7cd30df0a52613f8618cb6b0393602d9961ebfa7770e3041f7207b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a9e6be09d30e9e1e9ced650cdb0e9e20c7c2097f6f2fc3ab62912acc8a82d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f87aea61e36d6a2f447bd5aa4cf6a1e41b3e70ddfb8a086194d8cda980212445"
    sha256 cellar: :any,                 x86_64_linux:  "50f4a58c0f72d2fb01a8d419d5d3979c2894c33ac27eca64cb2161af5eb9ca8a"
  end

  depends_on "go" => :build

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