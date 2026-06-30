class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.95.7.tar.gz"
  sha256 "57f9e798d9d4f281acfb8b7d999f275d5641bbbe5c8a512e42da69a7ec394e9e"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6b9790e8126b406bceb23b32fd7d9754532895734d3797e5cc786800ac37575"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa84d87e976db8a92ce4cea5d4e0667c2ff2318aedcb4f26530e6ba36ad3d813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e83d393cee7dc8bd3fd268f20ac1821d6810865566ffab224daf6710a10dab19"
    sha256 cellar: :any_skip_relocation, sonoma:        "c81f53f8335a3e1e71da65d39cfc23c1e4c2ff47e00560895f15a2d8dbdff7f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5434cfc4ac86c142aef1da00c013fbae665686a0c8c9ade18ca6c66b58309f6b"
    sha256 cellar: :any,                 x86_64_linux:  "8916f998a2a984a83c440e7994a16d0c9e6082e577cc7b32eea3fdf87ac3151b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end