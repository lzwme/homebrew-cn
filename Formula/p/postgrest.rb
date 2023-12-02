class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://ghproxy.com/https://github.com/PostgREST/postgrest/archive/refs/tags/v11.2.2.tar.gz"
  sha256 "014db32718fd0c6c32a7bcf8331535ce8edcb412baeee697441668fa5bd50692"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "024b351150bb491e0f65a0490d96c9b6a54858ec4b4da9cef6efc797edcd5617"
    sha256 cellar: :any,                 arm64_ventura:  "e60ddc7e578bb77312a6879c12f0c36efc814ac16a7c6df320d660bf84080a78"
    sha256 cellar: :any,                 arm64_monterey: "dc589bd9dcd0d2553dafc98a074190a614c3cc569529a0c4b634a99d7f46eab6"
    sha256 cellar: :any,                 sonoma:         "7b609e82eae55ea78436dc8524805f2ea0e11997b8264967ecef1275bdfd1794"
    sha256 cellar: :any,                 ventura:        "b5d08a2bfcafd672e490537dbde130e3544f6a1e3764e48902fce8a233c5587e"
    sha256 cellar: :any,                 monterey:       "d97ab52764b6c38542932cfaa09d75a4616446f7a443d60ca76d0f73baea0f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b6367318ec92f72ad30a202138ce9b2211eb3de43cb34ff3f98d56120a3c5f9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "An error ocurred when trying to query database settings", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end