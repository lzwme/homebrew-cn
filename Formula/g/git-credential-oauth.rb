class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https:github.comhickfordgit-credential-oauth"
  url "https:github.comhickfordgit-credential-oautharchiverefstagsv0.13.2.tar.gz"
  sha256 "06da9103faaadf1e0d1f7ae9758f7193828fc9d7b3de246fcd8ef889450c5639"
  license "Apache-2.0"
  head "https:github.comhickfordgit-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ee8314cdb0965c7b024ae05121bf4ac85468c35ae19fc191e560700c9a6e05c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61ed5fb2bfb49a62c12881f4e0994cd54d4fc6e443daa383a52cf2dd40560b7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbecdc5e50f56631f50f7a1fde18758d3a7a2c7dfb4ef09d1b01cae3f9ca2e15"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f19761c767dfc79bb1f04e77449afdfc4302a8708ba771a99d5b0c591e281d3"
    sha256 cellar: :any_skip_relocation, ventura:        "ced5d0a52b0e4e349d7de219dc3dd056dd0ea452e69c062605331056c65a028a"
    sha256 cellar: :any_skip_relocation, monterey:       "226058eccb4a2dedea68cc1fc08c82b3058d3de57e62865e4bf68d838ac165d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a89cd3f3fbfff1234a2a7c82c09e52a3380336d681f7795a8c3350c57f0e69f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}git-credential-oauth -verbose 2>&1", 2)
  end
end