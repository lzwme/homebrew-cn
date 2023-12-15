class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://ghproxy.com/https://github.com/PostgREST/postgrest/archive/refs/tags/v12.0.1.tar.gz"
  sha256 "d758d1aebc60da5e5ff2d215eb1dcaa69d62ef88a14077536764ce90125e0961"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be3160e9f2deede91766994ab3e92221b9901866af6bccdabd3c19be6f8d7b39"
    sha256 cellar: :any,                 arm64_ventura:  "7ddbddb6895219a31215741f755cec8171af02c59993a232d5c6b3a862063a5a"
    sha256 cellar: :any,                 arm64_monterey: "a5f9c9c75374966f98b95b59b8e927a6326b52921f44982e339d8f6c7b405e3b"
    sha256 cellar: :any,                 sonoma:         "1fb0f7039ef167f740bcfdcf63631d68b2bf50c35744d6246dc8062fd26345b3"
    sha256 cellar: :any,                 ventura:        "5c6b38cb6a42ad2d699c4c0c655fbdf82fd6fc6fa164e7b268b2cb49ba2aee95"
    sha256 cellar: :any,                 monterey:       "a6311b349cda62e0b8202c29d0f8fe06bd4422d3b72b8b185d19f7502bf2ff49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dedf8e3a2d6df022869fd055e990706f870d5856cca312a5e376b03188befe2f"
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