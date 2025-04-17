class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https:github.comPostgRESTpostgrest"
  url "https:github.comPostgRESTpostgrestarchiverefstagsv12.2.9.tar.gz"
  sha256 "a9d8b9743ca1fa449c9afa67a2cf89a9a9a2d22dcdf490de38ceaec0f32217f3"
  license "MIT"
  head "https:github.comPostgRESTpostgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ec1e7d93bd70ba9c39ca5d81ac2b3a61b0bda8f31d4b85f7cffe3962f2de27f"
    sha256 cellar: :any,                 arm64_sonoma:  "44ee95f6aa5536a9f3e0494b108b60c7d5b28d8e6152a2ba536b5d7aa40ad935"
    sha256 cellar: :any,                 arm64_ventura: "24add2db5a34693314370e02b9019c8ec1bdb18c8d1f81e215580c37575bc35d"
    sha256 cellar: :any,                 sonoma:        "39d7785b0ca5d5479e3655f5321cc276a93487c8eadcb92f057b2aaa892a9f12"
    sha256 cellar: :any,                 ventura:       "32e12eda6a2035cb3c17524386a53875569b3b56acc1760d7584f53f33ca103d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "858998eb9d8a6c7f5fe489aa6e3f12e69b81ad0127bd820d173853a840500fd0"
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