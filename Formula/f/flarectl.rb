class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.83.0.tar.gz"
  sha256 "750f1ff272fd35f7aed3acea6ff3dec642d12b5a2607a998bbea60fda18f122f"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "272a1d7b72e85be41bec5cfb05bf3ef915dbe5ad35a23fc4d457a1442c45f6b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd054bacd268b280517263e9c7f4da0f595036d4f5cb52cf8b4ca86092bece64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "998651456d0df85c9ae437dd91ecf5e5ec63ee7df03bc4245dd5cfa87c253510"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c541481f48c48e1b07997ed420dc021b263e28ff9f95b51fe59f514431dc60e"
    sha256 cellar: :any_skip_relocation, ventura:        "26d9d77c3cfc69c15dd6c4ad3f5f911836b53db1ba7868f29fc6809e9b9a013c"
    sha256 cellar: :any_skip_relocation, monterey:       "893cda27f169caab9d13987cd2f0f96d47033f73a1605392493ebfdbdda2e313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b7ac7b89e182a5f7e77181e7749735424caaef8b903e6cefc5b5246c14e20d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end