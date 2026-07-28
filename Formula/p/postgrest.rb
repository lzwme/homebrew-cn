class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v14.16.tar.gz"
  sha256 "9ab4ba969c017be812bcf49bc3e86690fbbca25717655c2fc528728e4e1d479e"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6c046384f0b944feea78b2db8b8105fa9770ba5d6c017b8daec55f45222df87e"
    sha256 cellar: :any, arm64_sequoia: "1d77329e007d1dcda003c372448d65b1256740d2aa06aa5c7229313a45aeaab4"
    sha256 cellar: :any, arm64_sonoma:  "b7dfd1543b19406728a84325bfe2eea7fce2f203fe803405719acef21488da12"
    sha256 cellar: :any, sonoma:        "1ff73c565924f4d2b72db68835f866e839e201ae4910523baf99feb2e5772041"
    sha256 cellar: :any, arm64_linux:   "3df3412ed026d124e4d9108cf5610c3a4fc517eca0cd6b758a03b9dd8b52b0c6"
    sha256 cellar: :any, x86_64_linux:  "e1adeed258fd640c7a3af9e964f7c278822f2bc706103275554937590f8f5d70"
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
    # Workaround for https://github.com/fimad/prometheus-haskell/issues/82
    args << "--constraint=data-sketches<0.4"
    # Workaround for newer crypton not working with memory
    args << "--constraint=crypton<1.1"

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