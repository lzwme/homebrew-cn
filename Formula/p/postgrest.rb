class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v14.4.tar.gz"
  sha256 "a68d01b469b653420c579dac184a6dd85e6715a37996864dc0988e2ce73e14f2"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "86059bfb56c0261bbfbbc5533da53282da17944423e297f00f128e12b96dc0e0"
    sha256 cellar: :any,                 arm64_sequoia: "1904bc01270010b9253093eb5cce95c2d96ce2c73e9ddc7186f7de027763e1b2"
    sha256 cellar: :any,                 arm64_sonoma:  "11b974a2fa881e79a99641f01446e8ba90ac3fa51b96bcbc206d8654e103754b"
    sha256 cellar: :any,                 sonoma:        "084942aa0852c89ba2e7b33cdb0b84d948b35d04552bc947c4a10a11955e0032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dce853f3635c3b225d49446e36891f24af93d273f00e1f17033985512b128de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a1f56e76ec3240d0905431a3206061385acb66338c9ff0d996739c62e71def5"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "libpq"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build with GHC >= 9.10
    args = ["--allow-newer=base,fuzzyset:text"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *args, *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end