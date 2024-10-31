class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https:github.comhickfordgit-credential-oauth"
  url "https:github.comhickfordgit-credential-oautharchiverefstagsv0.13.3.tar.gz"
  sha256 "294c101155872d1a440aad31e0e8e85159a41fefa19c83ef86b6d22a5184d189"
  license "Apache-2.0"
  head "https:github.comhickfordgit-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a721f6c5816dda4be104c1f39f9f4bffa025777f9277312132cf0f2dea811b49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a721f6c5816dda4be104c1f39f9f4bffa025777f9277312132cf0f2dea811b49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a721f6c5816dda4be104c1f39f9f4bffa025777f9277312132cf0f2dea811b49"
    sha256 cellar: :any_skip_relocation, sonoma:        "313c9263d6ae9b35174b260203a6ea638609663d2e7d80ce250d1c96d1bc8d13"
    sha256 cellar: :any_skip_relocation, ventura:       "313c9263d6ae9b35174b260203a6ea638609663d2e7d80ce250d1c96d1bc8d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f86a85230ce4f7c854ae3b816ba3c35ffab8aa99b601f4aaedd565a7440ff7bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}git-credential-oauth -verbose 2>&1", 2)
  end
end