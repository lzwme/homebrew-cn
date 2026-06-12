class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.25.3.tar.gz"
  sha256 "488f81b1029cd4529b1e9b2d748ea5ec6ec8a9b628bb063c12a97ff17d40208b"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e8c2f00e68d41a06b5f76c51ebe7294d8a7347e19a6fec6796fd2268c647bc1"
    sha256 cellar: :any, arm64_sequoia: "73f0242a2eee7e03dea390dcbc2e3ee028920d9245dc2636301143ce172ec533"
    sha256 cellar: :any, arm64_sonoma:  "693d8bfb5fc9df20878c8c1abeacdc6ea6d48d0ff422c55c0609398771551c9d"
    sha256 cellar: :any, sonoma:        "1ae6430d927eabefbeab6afd7f2dead17dc7aa33aa27b6a03d153bab17f23f5a"
    sha256 cellar: :any, arm64_linux:   "38566b015fb27a2ab0d2c66f21be366dd44059e094f3205d78d09915033f6ba5"
    sha256 cellar: :any, x86_64_linux:  "adf8a110ccf578f9e9c198617264e0d9b62daf50b5dd434eca1b59ceab71705d"
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