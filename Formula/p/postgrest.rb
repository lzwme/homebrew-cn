class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https:github.comPostgRESTpostgrest"
  url "https:github.comPostgRESTpostgrestarchiverefstagsv13.0.3.tar.gz"
  sha256 "5faf2b65455547e22da99ca26f0286f5583841630102db2350836dc92bd3efe3"
  license "MIT"
  head "https:github.comPostgRESTpostgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc2a0b6dca743a6a4b39febc84f68133693695ea3d12eaa2adfa8621dca8a50e"
    sha256 cellar: :any,                 arm64_sonoma:  "73ac5b047d3503edd2a3012df5d57bba34cca9bb431b0a1527934dba9cf7bd7a"
    sha256 cellar: :any,                 arm64_ventura: "d37d2462a21de51469885d4a510c5baf7dc78c0b3d903e05aabe5acdf07d49dd"
    sha256 cellar: :any,                 sonoma:        "4247a500b08e6818ea61aa1d151e7afc6d0cac7b33b42d7ed5d158a5faa273d2"
    sha256 cellar: :any,                 ventura:       "2ab33929d12c77349f131f3876a338e7cae1efb64da9c692810479234d40a14d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58bda9b0ebc3730c38e04c5d37aa42f0e71cd332a456433501fe29189e82c64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ae64dd8a9ffb399e49846e20df031d3eb90cd845961d542e882a7b2a7b14eb2"
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