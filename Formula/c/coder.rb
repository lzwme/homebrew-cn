class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.28.8.tar.gz"
  sha256 "223661809aa6666fff90c98e4e256c11e7d2ac68547af73cd40bc228a79336e1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "342e1362aef5f93d06d51786cce0cfeacd7e38ef847b273adff1003145e81b49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc0f539450b3c44dd11b1a9df9214b4e27b1df5bcf3c68b1bdbc7db108405e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df74735b47be7f82383e2824c19ce2ec3b3f5eea58104da6c088468ad3d0a1bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "85a27846f78b48feb291265751d03e7e0a2b426e338f2a47eee7c1ac78a0d47a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76dedfd636a5b326dfbe1ec3e32e68055199e8cc4b85308d5cc6a8f499627ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ae5b7036d812d389687316b8cf74f62d16d420104a9ea67df85478f63a85ed"
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