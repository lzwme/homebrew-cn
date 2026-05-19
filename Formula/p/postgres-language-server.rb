class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.25.0.tar.gz"
  sha256 "274ba04ca851e2ff930fc1870d6840e138384825e47d3e557b637f4cd82a5066"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c1c20051a4146288329faa2e385ab39c8f58ea3e609c57f6b534bc3d1f61bcc"
    sha256 cellar: :any,                 arm64_sequoia: "4f0a2968ffb1cb42d3a1fff35e6c06ae6cace82215fb1eb41aef1263cfa4456e"
    sha256 cellar: :any,                 arm64_sonoma:  "0fa3f9a89f79ad0aefc216d812b0528104e174f07a5ba5f8fcfed1ee78cbae20"
    sha256 cellar: :any,                 sonoma:        "5ebcafe8f5ac9e67097d9583258c5ffe7dfb9a2da10c560a7b2d8023452b4c64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a58dff552584bebf5d32761c73532f6acc75a0757e160b7f019f43caa8bf01a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977bea47451e214512aba721903e4c3ccc7c810490979dff388bb26a9a6e0dc3"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "libpg_query"

  def install
    ENV["PGLS_VERSION"] = version.to_s
    ENV["LIBPG_QUERY_PATH"] = Formula["libpg_query"].opt_prefix
    system "cargo", "install", *std_cargo_args(path: "crates/pgls_cli")
  end

  test do
    (testpath/"test.sql").write("selet 1;")
    output = shell_output("#{bin}/postgres-language-server check #{testpath}/test.sql", 1)
    assert_includes output, "Checked 1 file"
    assert_match version.to_s, shell_output("#{bin}/postgres-language-server --version")
  end
end