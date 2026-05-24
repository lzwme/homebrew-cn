class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.25.0.tar.gz"
  sha256 "274ba04ca851e2ff930fc1870d6840e138384825e47d3e557b637f4cd82a5066"
  license "MIT"
  revision 1
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8067d1c2920c8c0f6870f9ed1517c897314336d4d646ec0f655ffaf3704d20c4"
    sha256 cellar: :any,                 arm64_sequoia: "cc6db2f42c9d8dadfd7e47fc3d594bf6ce2d520c9445c9358a5ad1f9e30b1e84"
    sha256 cellar: :any,                 arm64_sonoma:  "d9359069efba585bf037e5b3c1b5f7750d6ce3c8a282205eb8dd09d9080f2efc"
    sha256 cellar: :any,                 sonoma:        "512b689c7548660868bb080d0f3929104cc754b4b7308ba87c5e16282fba1247"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "794c3fe9d145007eb489f2bec3eb8ed18f804087b4729d5f3ac9bdfb7e371610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78940cd5baf973009ba8b2b49d3393560891ce081d020ba30d2ab2abdca454b5"
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