class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https:github.comPostgRESTpostgrest"
  url "https:github.comPostgRESTpostgrestarchiverefstagsv12.2.4.tar.gz"
  sha256 "c83ebb120eb97d133d9692cd4dd40780029dbff1950c4c4227198ceb5cf6deff"
  license "MIT"
  head "https:github.comPostgRESTpostgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41fde79e35163d6aa8b7b7a63088564cfc9c7c040dd63524b8ab37e8cfd308b8"
    sha256 cellar: :any,                 arm64_sonoma:  "5a433b93b413dad693ad729a169dd380781f39586643bdf0ff6e827a92547e08"
    sha256 cellar: :any,                 arm64_ventura: "1bc7a589b2c890806cf696bed2992eb599b764a687daadbe4b663feb531d46e6"
    sha256 cellar: :any,                 sonoma:        "1631b65a7ec86bc0fbe7513058ef9bda7425b861f3a0ea9601ec211d49fed5b8"
    sha256 cellar: :any,                 ventura:       "822b6763e19def87694156a8a92dd6fadaefdfd9daa3e09a02c708d674bf92a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50216bcbb953d5331b04cb40c67587bb5744e61df0d613ad59f4a80d69434684"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build # GHC 9.10 blocked by deps, e.g. https:github.comprotoludeprotoludeissues149
  depends_on "libpq"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}postgrest --version")
  end
end