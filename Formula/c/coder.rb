class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.34.7.tar.gz"
  sha256 "297516cd6cb9d83c79f5173d572286f8029f3a1fb99b453f2e62769a0555071e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2ef128a1e73f9d2393a745f673b4402d848191572c0e0e4589327c1f2fa8062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ecfcda7eb46098843f9496e17942e4e451a98eb59473de7023db22ef21f6ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b21fb74509f43acb32dc3dc1e5f5f737a5a2afe3449c9623021adf783d49590"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c695e8d8fe8ae12d48c9c3fdf7be498f27adeec879b6723df92e9b6bf6e03e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83764fc86d6441ed6e233d0218f9141ce40ad4f1c7ac31c21209dfae26a1beb4"
    sha256 cellar: :any,                 x86_64_linux:  "7fb9da8a1edb7e0790a46edd999042734a46a77f64afdebab3ed8337e77eceb2"
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