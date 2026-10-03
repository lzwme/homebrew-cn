class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://ghfast.top/https://github.com/kenn-io/msgvault/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "25285e2281238e64f5c72c1a1cc54e8a3f0351b76ea6dfb7c6971f4566276e4f"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "df935de71931b589f303837f134c1d9a4fa3934377f1d8f5639c304a44b3e4a8"
    sha256 cellar: :any, arm64_tahoe:       "ba685300bd8eafafd8a99c6cfbbbbbf927b5472fe86564045b5e966dd79b57b2"
    sha256 cellar: :any, arm64_sequoia:     "646b7a4a050b3f38422f137a8c273d00a6455c04d83d250827361e40caca3b4d"
    sha256 cellar: :any, arm64_linux:       "f1d4f54786ca6188261c1dbefe48c9cb4dbe9a857222a82191e79f015f2f0451"
    sha256 cellar: :any, x86_64_linux:      "0c0230a82301e3d7f194298cef3175b1e6726c34a1ff3ac4870d0f23154a18e3"
  end

  depends_on "go" => :build
  depends_on "duckdb"

  uses_from_macos "sqlite" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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