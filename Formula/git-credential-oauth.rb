class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://ghproxy.com/https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "f09304c1233524c52d483ddc7899f2ed44747a257522ea8c1bb240446c40d378"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44824dd9daa64899281e0b4f85290f9cade2d857fd62e1e08c7592c47a7fd5f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44824dd9daa64899281e0b4f85290f9cade2d857fd62e1e08c7592c47a7fd5f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44824dd9daa64899281e0b4f85290f9cade2d857fd62e1e08c7592c47a7fd5f1"
    sha256 cellar: :any_skip_relocation, ventura:        "84a8fb3b1dc249c9e3ad94a16d16746700f4aa19f29360d79dee88ce0473ff3a"
    sha256 cellar: :any_skip_relocation, monterey:       "84a8fb3b1dc249c9e3ad94a16d16746700f4aa19f29360d79dee88ce0473ff3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "84a8fb3b1dc249c9e3ad94a16d16746700f4aa19f29360d79dee88ce0473ff3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47989580febdc3044f47231a010a5738c9ae0dada9d2d94ffc9723be1ac0bba2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_empty shell_output("#{bin}/git-credential-oauth", 2)
  end
end