class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v14.0.tar.gz"
  sha256 "133a75bb978f2bd41f24cd80d2fa42165f1166bad90260ec8b1188b9d2d948db"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "50cb13ac153d5b4af1313f111aa7ed2142e594a13fd7df02a76ccc11a9d8537f"
    sha256 cellar: :any,                 arm64_sequoia: "7968e91a1c44bd3a3ee644e997a8f362f3ec7b07cf42899defdec3cb0634c83b"
    sha256 cellar: :any,                 arm64_sonoma:  "7342540cf0f0935200feed7f320590a86905c5624f0b48ac5d450eb95502e27b"
    sha256 cellar: :any,                 sonoma:        "3bc80f801836514cc64a84269a8cf4cac48b5cf2b722bff97b09f68dc313a051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68071f10b689caf583af267634fff03e93cbdbe423ba0fbc9d320af21f6661a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae22c943d8b05c4ef78847d7371483cabdcd68360ca7f4ef5fce99cae63f0867"
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