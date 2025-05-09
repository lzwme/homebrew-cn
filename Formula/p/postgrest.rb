class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https:github.comPostgRESTpostgrest"
  url "https:github.comPostgRESTpostgrestarchiverefstagsv13.0.0.tar.gz"
  sha256 "61273ba81af1c84965695f35ff058da576d968b70a781ea6445701cb75929b97"
  license "MIT"
  head "https:github.comPostgRESTpostgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9290700cd7ddb3a617430c9c7cc3e12f5ba2c1195b8a4c9f0c822ab4cf193f9"
    sha256 cellar: :any,                 arm64_sonoma:  "ee9085f8de34c1a2e99cd8ed6a0b3b22fdc2722d33c546f8190793caaf96ce09"
    sha256 cellar: :any,                 arm64_ventura: "395ae0c69a1e06db5bd4339b8ca40a9a9f8241ec7c0730c52a81d139e15932d7"
    sha256 cellar: :any,                 sonoma:        "f0a37bbbc2f54ae0ed72a91e0759dcef52e58841cb283c2f473eb408f912ff03"
    sha256 cellar: :any,                 ventura:       "e00742b17b0999d69eb31c6c45953b2ddea0b7f2e9656c145a6908127a9c4798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9e02e34c6dc43b24561992a65f447a668e5362850edb3c6341327b8dbfa8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d14fa04538cd872c63ed61c2ff303e0e7104219e0ac455c95c23913a6264d0"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build # GHC 9.10 blocked by deps, e.g. https:github.comprotoludeprotoludeissues149
  depends_on "libpq"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}postgrest --version")
  end
end