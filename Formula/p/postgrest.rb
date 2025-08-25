class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v13.0.5.tar.gz"
  sha256 "b76a7b695c448526b9a0bad6481f7c788fc611f7976d26856506a332ddf7864e"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "430c6caaacbced66d09af7c077bb627bd48992d51a3334ef7d40b1ebd190f4b8"
    sha256 cellar: :any,                 arm64_sonoma:  "5237f53ba5be8dc0e0e72888f95bfb0addc391a6d5232ab3bb127a97a90c362b"
    sha256 cellar: :any,                 arm64_ventura: "1ba799e10962c6bd139963f1509b715ff4d3996a10dbd5e97413e9f192c8f700"
    sha256 cellar: :any,                 sonoma:        "93c4c6d0914495d76c5fba10ecd46d2888fe7458efcf389416876bb0dc9d4154"
    sha256 cellar: :any,                 ventura:       "4c8b80c4d5b192fb13665d64e25b0ebe1aaf72128709f197eeb1d1c68762d247"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "133f19f4adae6ef7f4f96a33c71f090c61325abf1a2a1a1903cf1778289b92b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16903a312ff645a66faf4fa87846a9355e291a20466e1f8f067838807d17f130"
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