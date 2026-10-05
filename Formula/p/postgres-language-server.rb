class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.27.0.tar.gz"
  sha256 "05b3327dd9e6051d870d8907ed94793c7e2744e7dc80193b3775c971fabfca7b"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a994cc196618e8d23e029fca032099cfd1534c6c262c102b291a63d07c7d529"
    sha256 cellar: :any, arm64_tahoe:       "c999adf177b0aaaaca80146d3a24cf1e53d00e4eb20ac6d7ea30753bc8efd1a2"
    sha256 cellar: :any, arm64_sequoia:     "2e0e8d15fce85e278ee9fc97cd4474831885d1bd1a3e8e28815c53b2f5860278"
    sha256 cellar: :any, arm64_linux:       "c9603f48caa268cbe270bb5b1e1cc864d375d52f171b11ea290898a884f58c29"
    sha256 cellar: :any, x86_64_linux:      "48cf9c598cc58d45028916a21faed52bad057dbab1ce5b8fa284b6a96a014504"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "libpg_query"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["PGLS_VERSION"] = version.to_s
    ENV["LIBPG_QUERY_PATH"] = formula_opt_prefix("libpg_query")
    system "cargo", "install", *std_cargo_args(path: "crates/pgls_cli")
  end

  test do
    (testpath/"test.sql").write("selet 1;")
    output = shell_output("#{bin}/postgres-language-server check #{testpath}/test.sql", 1)
    assert_includes output, "Checked 1 file"
    assert_match version.to_s, shell_output("#{bin}/postgres-language-server --version")
  end
end