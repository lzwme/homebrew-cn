class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://ghfast.top/https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "61a79ffcb51c2e3a37ec56c99c4d9a738322e0f47fdd6ffaf456a38589f27877"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f5c8e88f9e430e717d99119f25da63120519895b039586254bbc7809e151634"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5c8e88f9e430e717d99119f25da63120519895b039586254bbc7809e151634"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5c8e88f9e430e717d99119f25da63120519895b039586254bbc7809e151634"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d7b92483e2634648b39b2b986bde39e91765c7d184ebe19c0d4b3058e74a3cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afac6a03d359333cc0a1e8ee2120316971ad236e1577d9ebbf02f1318c4190c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "447608b189a575d4445b62925f716e9caf1fe048fa8e706f6a98346ad7dc2c66"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end