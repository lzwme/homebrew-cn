class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "401d999664094819e7cb1e5d7f699e23350e0e8756a21b673c9f9ad606d5f72e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cced7dafb32f7fd51c621c27be961471f8f6f0804660d8d3a11752266b16dada"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef840ae983336d48d187fdcbc912970c59c0e1a0f7cab9abaea5e016c0ba1735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59958abae6fe1ad137c8c5a947113dc9a848b81c0328b43392f73381b2120f4a"
    sha256 cellar: :any_skip_relocation, ventura:        "1e955a8fe925758d7a726c09af5b822eb6a75cdb9cff62076031ebe919cd83cf"
    sha256 cellar: :any_skip_relocation, monterey:       "6e85e090a157843a876847f74bb1f40f0213c06c72a942717f0887f26be1aa54"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0f932f656a3bcf70f97b0280ffb47f36fd9722308cf8e9973cd5be96e0b2259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1501ad6bbe7894d111dbda345274548fed1bec442caf17c510047d82079d7b92"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/coder"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coder version")
    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
    assert_match "postgres://", shell_output("#{bin}/coder server postgres-builtin-url")
  end
end