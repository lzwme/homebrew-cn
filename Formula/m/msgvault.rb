class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://ghfast.top/https://github.com/kenn-io/msgvault/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "7a29b4f136389e18d47d5ac5262ea6c7c286baae42749e3ca110b4c174199397"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7cf62b92f8803a9ef6d4f5a033ba43a7bb51dfe1a0e6d96542c89724b4320828"
    sha256 cellar: :any, arm64_sequoia: "170d2651473f99f07211180538d6948f3324a369ed037b8f7f0c2a5389db168e"
    sha256 cellar: :any, arm64_sonoma:  "7b0521c08a15c4f5e03adc10bc3487b84cf0e40fafe89e91b181df7540faabd0"
    sha256 cellar: :any, sonoma:        "8a5e2e4ef30120d78ce62924ca0e980f1a159e2371ac816d58cc981712083aca"
    sha256 cellar: :any, arm64_linux:   "8f3b5bb432f8c58032b44e98fa3de41cf440639564fdf4e6d0caed20c1c448ce"
    sha256 cellar: :any, x86_64_linux:  "d973eb476986c805a3ca74c7d52cbc127503dbf663694d7d21148e3fda2758ea"
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

    ldflags = "-s -w -X go.kenn.io/msgvault/cmd/msgvault/cmd.Version=#{version}"
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