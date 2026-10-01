class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.26.0.tar.gz"
  sha256 "c01ed5ee8c019b4ac8d90a6db378e50a74cbde0a227cf28193b4fc092112a5b8"
  license "MIT"
  revision 1
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8861619f71074c8b829d0f0cd96f765b6e6900b6da511826250b2bde96843710"
    sha256 cellar: :any, arm64_tahoe:       "c4c3ba958a673ae00416ce33365d78054fab64b56c21651969edd7867d5404bf"
    sha256 cellar: :any, arm64_sequoia:     "be447b685e769480e0f698562d109d7d6230177ec4e38ab7df3278a7b1d55377"
    sha256 cellar: :any, arm64_linux:       "5080f287b693bd417da3818e330ea9d33468ac7d574daa4f29bb235bcb9616df"
    sha256 cellar: :any, x86_64_linux:      "4d79bbab40884a34c2b05c4841d0545b4305f0435cb183e6152b536c29ae7cdc"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "libpg_query"

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