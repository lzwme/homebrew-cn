class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://ghproxy.com/https://github.com/PostgREST/postgrest/archive/v10.2.0.tar.gz"
  sha256 "23d63292d50d303bf61154061704f642dd3d699367e2ccb159ec7604f2848487"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f341e1de51e4be3d681ca794686b4b76abdbf201d2ceed764496791d9d628ffb"
    sha256 cellar: :any,                 arm64_monterey: "84e33486358fde32a3b8e63f36fcfb8b541f5077043a86447f75107d2be57fc8"
    sha256 cellar: :any,                 arm64_big_sur:  "f22ef87c556a27f20375465a6710a982cf34b62d8681c8813d30797444325d95"
    sha256 cellar: :any,                 ventura:        "421278164cfdfaacb00f0ebc1fdbead63dbd59d1a0f8d1abb1a7f2bb60e85b49"
    sha256 cellar: :any,                 monterey:       "a28d931908626f67bb2ec7721ea85a11269d87d482247801aea43a6f931e03a0"
    sha256 cellar: :any,                 big_sur:        "b353a1d8d9d996de113425b10342c3ee09b011479bd8034db9e98b279274bfb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97f24861863d4c2e82f7366f005926f7932f7bf4cd7aa6a3906f7916e88d8b97"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end