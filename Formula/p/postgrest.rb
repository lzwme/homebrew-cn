class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v13.0.6.tar.gz"
  sha256 "4836957084172cbf8cfeaa51f5627a93c2fe8f36e2754ee8a36b003391164991"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e4c0251465740187347e790454e6b37c2d13bda5f762aa700f91e401127b835"
    sha256 cellar: :any,                 arm64_sonoma:  "f07985fb690d39e929fed8cc2afc126f05ab4728637cf89e10d50c486d50834a"
    sha256 cellar: :any,                 arm64_ventura: "6e68cd9fcdbdea8cb3440cc19faa5376b30ff8595809d2847e1ff13f09631a05"
    sha256 cellar: :any,                 sonoma:        "8367729296aeedd5bcacb3bc8f2f845a5a6dd4ba79cbc8b10b3fb5b6a604b927"
    sha256 cellar: :any,                 ventura:       "de25a70d01f785dc7ade00c5a66b916133814e14bd7ee0c7a4c99825c811d66f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "743c70deb79df82cda0cc7bf865cc5af9232c09a8004ebe81ce85091b88f3b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7632a39ab324d220cb4aaa29c05b7b3587e82dd6e76e468fde232bdde1a73ed5"
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