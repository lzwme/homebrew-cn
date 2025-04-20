class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https:github.comPostgRESTpostgrest"
  url "https:github.comPostgRESTpostgrestarchiverefstagsv12.2.10.tar.gz"
  sha256 "ce8c853a17e625819f97aa683ff9b654ba5c58b04f17902874324409f912bac6"
  license "MIT"
  head "https:github.comPostgRESTpostgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f7788c8386907e2a34eacab299bd3dea41eab9096d173046419d7ca1cfe3077"
    sha256 cellar: :any,                 arm64_sonoma:  "be9df04b49b458acf5c002978698f3ea096851d66397d940b916ffc7e1ecdbd0"
    sha256 cellar: :any,                 arm64_ventura: "2f9895d469a47ea0deced904cd3415d46f7d8e4f3f31cea51c341b9005c812f0"
    sha256 cellar: :any,                 sonoma:        "2c9208feb13c1b51c5387d01e69753b23845c2318f2d474e45b8bc5ee155bea8"
    sha256 cellar: :any,                 ventura:       "524baa038ad9bb38e69402e842cf7618c0a4a6c25b2cb7fdbcca76320b27b054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15ac101f4e5d98ef967a90223fa4b31cdcba654766297f1e778af2c3c8022fe3"
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