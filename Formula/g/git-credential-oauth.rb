class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https:github.comhickfordgit-credential-oauth"
  url "https:github.comhickfordgit-credential-oautharchiverefstagsv0.13.4.tar.gz"
  sha256 "fa3f2de33b5a3f5d59aaa48073603eeea5405d750e5264e507c9cd8049f2cc89"
  license "Apache-2.0"
  head "https:github.comhickfordgit-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb87e1ddd6a3b9e8a5e215786f3387abea7c5243f356545aa547dbe36640714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb87e1ddd6a3b9e8a5e215786f3387abea7c5243f356545aa547dbe36640714"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bb87e1ddd6a3b9e8a5e215786f3387abea7c5243f356545aa547dbe36640714"
    sha256 cellar: :any_skip_relocation, sonoma:        "14257aec08dcf92ca92b1013b81f6129a19a03c98ce11f0c5f2e26f97e828933"
    sha256 cellar: :any_skip_relocation, ventura:       "14257aec08dcf92ca92b1013b81f6129a19a03c98ce11f0c5f2e26f97e828933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e5d9af07a696b7efd6b288c72cc0e24e8ef3379810644275861ada5aaed2f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}git-credential-oauth -verbose 2>&1", 2)
  end
end