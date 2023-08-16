class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "a9c2a996cb916ef0d74c1cdd2ccf30f95b9953618ce2d504a7477eb2b8b655c2"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b186e397d831c685fd02e1fc14164873628aab73ae4bff23f95516c058c26fef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a3163174a7ece89c2377803f22bc4cf6cd0223ce5e7170c2d17f098793f762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b171b0eb5e9dada9123942f078e600fcd35b7599ab584f8bec95020bb4ac929"
    sha256 cellar: :any_skip_relocation, ventura:        "b935c29a44f0c97c9d4849029d3d8fd1a489c2fabcd938b21fe7ddf1aba88592"
    sha256 cellar: :any_skip_relocation, monterey:       "521fd048b8d1fe9a7f1a7755f0c10bf6a668ca6970540a0a01193dc1e7e93cf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f56154a06f23fdfa286d4300e27e946614d197c92cf58e16372866d2df4470ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d7082c8c547ea6bf5c0bde81b809cd4f667ae6f1ca4ea843ce62b00bb89e792"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/buildinfo.tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/coder"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coder version")
    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
    assert_match "postgres://", shell_output("#{bin}/coder server postgres-builtin-url")
  end
end