class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://ghproxy.com/https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "324dd0c7d2692c6bc61c8f054fe3870a45584720502f765e8faa88811b7167cc"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7a5aeb8aafae8e93044a882827b62e3f331abc3402916acb83732430e258eb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed1ac4f7647852451aeefcf7da02362f5f05e3612526ef47047c2fbc0620aff5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3814b38d39fd0b242c059668ed7c16310b7ee0b78832b7be1453e44f03b45015"
    sha256 cellar: :any_skip_relocation, sonoma:         "53e9e8b0ea4b6525ca5e1d6c9a5c452be73759131af33fafe092dfc71f003031"
    sha256 cellar: :any_skip_relocation, ventura:        "d92df5253409dfd81386ad48bb4c5d48cf02dcc0bb0f1334a855b46d1c558d0b"
    sha256 cellar: :any_skip_relocation, monterey:       "2599bd4f7d6ccd14c409321648e1f82216c0542a00da7cc6926c4a54332f99eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c1e36c953f49d40205e2caee0579d8f59d0c3f2c7ab14515eb40e096767f512"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end