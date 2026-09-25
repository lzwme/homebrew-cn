class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v16.4.tar.gz"
  sha256 "303a4d9d32a9183247f5bb48ed4179e23954c73cfbf69ebcff9f5ce3f12905f3"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0e2b09b8542cfee9a93d699d3db2aef4bf477d260e473508213104edccdcdb45"
    sha256 cellar: :any, arm64_tahoe:       "d72d38ee1a8200a4409482bae86fddb4afbf6897bded60631bf46fe706170637"
    sha256 cellar: :any, arm64_sequoia:     "a9d123a10e550aefd6dd24528062691df7e6b0e0fc886400b3b3922535f3d9e8"
    sha256 cellar: :any, arm64_linux:       "e84dc31a28ad0844577fbf0478231ca5742291ea2b8f074d382ea91c51aa0bec"
    sha256 cellar: :any, x86_64_linux:      "b692b583dd9c5a63ce35a70f63c2eb580df0a14d8933af4bff0b9b70cbfac9dd"
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