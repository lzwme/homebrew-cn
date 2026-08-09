class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://ghfast.top/https://github.com/kenn-io/msgvault/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "3c65a6132033b5dab8a1c6638f38590f84b2bb0572b22546e07e6d7f6275a39c"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "84c58da82900836fef598d595a800e7c960cfb8e1ff988d98d601b51335b5272"
    sha256 cellar: :any, arm64_sequoia: "95d3efacd7c62cbf5650d280001c47675975b30b2d14677a26e6725837f70167"
    sha256 cellar: :any, arm64_sonoma:  "7de25aea5824f7fac13fada86a86eee3cfc215cbdbe2a750efe8c7a524eb3633"
    sha256 cellar: :any, sonoma:        "5730939598f8f046478cab548824f53e31cb7bef03cd1952ff7188b27c62e478"
    sha256 cellar: :any, arm64_linux:   "2616877e4c1e8727365401204cb83ef95c61cacac22463309506340662bbb2e4"
    sha256 cellar: :any, x86_64_linux:  "80ad3e871b16db82182dc1779f11880e0c0985e50413715178f2317445527fa2"
  end

  depends_on "go" => :build
  depends_on "duckdb"

  uses_from_macos "sqlite" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    # DuckDB is linked dynamically against this formula via the duckdb_use_lib
    # tag, rather than the duckdb-go bindings' vendored static library.
    ENV.append "CGO_LDFLAGS", "-L#{formula_opt_lib("duckdb")}"
    # sqlite-vec's CGo binding #includes <sqlite3.h>; macOS provides it in the
    # SDK, while Linux needs Homebrew's sqlite headers.
    ENV.append "CGO_CFLAGS", "-I#{formula_opt_include("sqlite")}" if OS.linux?

    ldflags = "-X go.kenn.io/msgvault/cmd/msgvault/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "fts5 sqlite_vec duckdb_use_lib"), "./cmd/msgvault"
  end

  test do
    ENV["MSGVAULT_HOME"] = testpath

    system bin/"msgvault", "init-db"
    assert_path_exists testpath/"msgvault.db"

    # Build the analytics cache, which runs DuckDB's Parquet ETL over the (empty)
    # database and so exercises the dynamically linked libduckdb.
    system bin/"msgvault", "build-cache"

    assert_match(/Messages:\s+0/, shell_output("#{bin}/msgvault stats"))
  end
end