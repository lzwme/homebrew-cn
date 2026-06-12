class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.33.8.tar.gz"
  sha256 "948adf0bf16c4bdf6be5478bf4a3a2669f3c9288f33c49508872d4a00da72bcb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10608a516817db315defcaa78a66fc91a3e82db7043a00a9516dc064c7c3aac6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0306caad472f511536b5e81e0d6198d59c42faceadb03a143401a0075d40414c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "363fa4dbe7780919a075938f6b530d36eb1c0a026b11c5bb4016b83ff6233b4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cd8313b056acd9d4678c7a5009edc148f51c19afe62a66992eb74c9ea513e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3d0ece8824b8533c102a10fbea81957ac0a91b4ee57a8b95a70a7d6be99847"
    sha256 cellar: :any,                 x86_64_linux:  "6fa9b519e00dee7ec45fed0b2f9543db93d13b501b8cf92f48d5a20879e13a56"
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