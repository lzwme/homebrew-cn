class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://ghproxy.com/https://github.com/PostgREST/postgrest/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "ab38016b25a635543fc3fb4e699ebc303ae9d8e2377865fcd1096d35da8b3f4b"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a633bd1fe6516d3f6a3fcf1d9097d2489608317c7083832dad7d571ed48a1c52"
    sha256 cellar: :any,                 arm64_ventura:  "7ead6e259b6611026879d32cdcc846a92b16533a901785791db6a88503c0b989"
    sha256 cellar: :any,                 arm64_monterey: "f00e87a8c5f04e726e94169d40dde900eec0f893ebbb24887b77f31b9e4ecfa8"
    sha256 cellar: :any,                 sonoma:         "13bac1541eb3a63827fb1c2d6a9cc4d363d38c82f2e93a5baeb6840c6da2e57c"
    sha256 cellar: :any,                 ventura:        "311390be0bab0257edd55eb13f10cb5de4662362ae028aba5c97d7f0a77bb6ad"
    sha256 cellar: :any,                 monterey:       "e0eef60636cc1005ec5c4feaca34ff3ee5911b838e0963343b0d92babe8ea098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2785d5ec2165ea1e921dbfbdb475685a22ca1d0387a77aa4c581058bbf22406"
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