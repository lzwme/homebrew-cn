class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://ghproxy.com/https://github.com/PostgREST/postgrest/archive/v11.0.1.tar.gz"
  sha256 "56459972b41ff647b46e0786cb04f208ae49c892ff8fd212b565eded794032fc"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "474773a6158cc5f4f02623ae6a389711ba1e4f47efcba1cdef4c498028e33727"
    sha256 cellar: :any,                 arm64_monterey: "056ecb59b0d315c002f93145f4ffbfa3f1ba62718a3eef34012b8e3ad2716bf3"
    sha256 cellar: :any,                 arm64_big_sur:  "89015592acefc3de4b0a8a15332d2863c3f8bd11edc51cf585afab897b5a0ad6"
    sha256 cellar: :any,                 ventura:        "c7eee5c47cff6982321cd0d8d2c6beaa1566935ef0d6c011d6a9947db5a7345b"
    sha256 cellar: :any,                 monterey:       "b41814d76e84ae9944d9edce083c10d58e2848808709b9c53043ab1ecece4c6e"
    sha256 cellar: :any,                 big_sur:        "3c036054b2bf8a0d984b931d85e339b254b1aa250aecc51858d58d5cc8f6a681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40fa1be61bb6bec510b0959ba69cb309627dcb72761c4430321eb9bb74dffddd"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end