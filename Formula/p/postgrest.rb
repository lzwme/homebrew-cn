class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v13.0.8.tar.gz"
  sha256 "8bf048c1f162115b028d2dfc87bdd67f49d34b079887e819cc1964d511adfff4"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bebf80426f629b2665bd73c038cdd90979ab96a3b7ff0695f72ccd9b0fc00a3e"
    sha256 cellar: :any,                 arm64_sequoia: "ba26468c926cbded09745de35f37727b15de0314f1f571290566b470df4d07f1"
    sha256 cellar: :any,                 arm64_sonoma:  "7f22ff7d8a600d43936a16d7fdc6943f5f6c85bd0adb56e359e15d168308f4ce"
    sha256 cellar: :any,                 sonoma:        "6fd105ce10ede52ac01905f390d0f61f42b823409690f69a3d22906d84a116cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9595aa9bb2a783897a5469f846930d9375ef12f0a0082612fc823ecf08cf2a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ab67b7d265aa62cef5a51af4489f743baec169bc2d680f58191b27f33be6e3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build # GHC 9.10 blocked by deps, e.g. https://github.com/protolude/protolude/issues/149
  depends_on "libpq"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end