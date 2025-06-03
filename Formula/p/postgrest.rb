class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https:github.comPostgRESTpostgrest"
  url "https:github.comPostgRESTpostgrestarchiverefstagsv13.0.2.tar.gz"
  sha256 "b6e989bf0c9e05c30a847de145b31925f8abb135a917eb90d89782c263e2d0f5"
  license "MIT"
  head "https:github.comPostgRESTpostgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "975cf3a08b5a8f9caa0c24f07b706c8fba9c025fc7a1c4d175a4d7f5e2398e86"
    sha256 cellar: :any,                 arm64_sonoma:  "340ffde4dfa0ed3ebbbc7e4fcac61393e4a3611255360164424cef02b2db92c9"
    sha256 cellar: :any,                 arm64_ventura: "548caeaf6342837395e2ab9679e2daed9df24072b94ce0e6302364bc57867341"
    sha256 cellar: :any,                 sonoma:        "761882ae17ce2e855cbe8705c27d44bb60469ea6e121915a8af49b6125884259"
    sha256 cellar: :any,                 ventura:       "fba7253f8b22c4dabb49a55ec27b5b81bc234644946aaa8ebe5b652264a5ca4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d847b8c675bb98aed0165dccb4b7aa41f6584505996d76e914126c3908d24685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5ab7fe33de3898e34933f774345042c692c33e076cdb27e9b68ae9806fc525"
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