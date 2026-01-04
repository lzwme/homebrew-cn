class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v14.3.tar.gz"
  sha256 "8dbf8eff7ff94b592a7efd5e9f9987675581298233b3b9d549ecf8fa598ce104"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12a1571e56b3eac5d776eb280237f864e56f0309437f5f77d2783864a5e997a5"
    sha256 cellar: :any,                 arm64_sequoia: "509e5e62f463cf8cef263642819fef33a40841207bbcc0b2d13ff90af64f371e"
    sha256 cellar: :any,                 arm64_sonoma:  "bc966cbf541f884c5d6c4c9b0ca0b727f610a7654d6bb815bff36c2fc81a43a7"
    sha256 cellar: :any,                 sonoma:        "9680ebea8832ece0af07e962352f1fc0ceede0e143fb85cd83eecc245ca368d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d738c830fd2d2de67a4ba0e1e5fd2b05d6a0bc36ff45d4de3e1b60f29811af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "413a3fe3adab1264bd7be2a066083bb55ebd166a341b173625a39180d1eb248b"
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