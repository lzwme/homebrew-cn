class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v14.2.tar.gz"
  sha256 "b76714d03c65fb42ea7b16e20bbbb4760d5260d41e4bff9c3717fdb6611baa0f"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9be1ff1918ab2f84860c5fc6621ffd97ba129f42151791f20de46b9c6ef2bcf3"
    sha256 cellar: :any,                 arm64_sequoia: "2defe3e61d0ca2450af6fc770a3ae6d2e8cb230486e797ca85e672e993589958"
    sha256 cellar: :any,                 arm64_sonoma:  "eb0aea6b03922d1b442c734ce62f19ce0b8b14499b1e8a2ed91fb7dcf61f670c"
    sha256 cellar: :any,                 sonoma:        "541e626db1e0edb284349fb465d7a617cad7df176b10e5b5c49086491b51a526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d4fb716f1f7585cfd88b56130616186912e98abb8035e458b7c524995219b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ccb2dce3875cad6fac72342e894420b3fded8b6a7ddc86a8e022524bd45ccba"
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