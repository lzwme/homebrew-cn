class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.32.5.tar.gz"
  sha256 "a12ff06e1b3f3506f867d50d88a61c6197950608575a271b61c94ff4ac237c4c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5726e62e6281245c7b5dc7d5bc62861620cf39623b6202051b900aad7e2bb7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0981517dbabb5cf65ec3cc309b8a16ecc391f65d2ae88732ae6fc132d034d6cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e9e2f4de673bda9cd54098b458d2ad29d0fd0a1dc9cf60b4fac3aa44f4688fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d0ce29469db5b8bfb70ddc84fbd1fa48d83fb17502b3a246edd7a2780f4116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebd46e42a310a346f032e88a26065239927ea82f4db58452aecc2d1c75f40d90"
    sha256 cellar: :any,                 x86_64_linux:  "9ede005571f029ceb71f8222b0a21542ac8c09ed82fdca8d825adef42a6be290"
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