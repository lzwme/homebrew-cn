class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v16.0.tar.gz"
  sha256 "eb3cb99dbc019f9f029aa63b6800b8550269e0cd3764588ec971d66768e87156"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6da7866ca3adbd87d60bcc384d2ec7be3d1074d90a8d251d6e8f97ee5834920d"
    sha256 cellar: :any, arm64_sequoia: "fa637339a6272c31121b13cb0e6fc5e22f558368a420400460e74db5b9e764f9"
    sha256 cellar: :any, arm64_sonoma:  "ca2d27277dc3a268a74d12c15f5f7aa4d345939ec7e9a3e2f4775cd14a21c38e"
    sha256 cellar: :any, sonoma:        "9e24076a73076ad01f2faa4c3edb18d06e6577d7d4e39710e92efb79efd14fc5"
    sha256 cellar: :any, arm64_linux:   "b3cba764dde6f493bd6d194c1584093108d680939cc351705fd0b69835796b23"
    sha256 cellar: :any, x86_64_linux:  "aab4d242d1da6bdad174aa0e45623adc347b09eb0d53df481bb1fc32f586483b"
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