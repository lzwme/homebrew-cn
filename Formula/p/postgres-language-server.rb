class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.18.0.tar.gz"
  sha256 "e40dbf0301ea345e18885b0710187f08bcad2e3426f3b24181b8efc8cb357929"
  license "MIT"
  revision 1
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac74ecbf68863811c3327159d268ab8d6298a8f4bc99a515f4dacf5676a4d1e3"
    sha256 cellar: :any,                 arm64_sequoia: "6dabe275e318ab71eee4d90c03869eabd5ff89e94ae8616a72b2d0c6cc1a0a71"
    sha256 cellar: :any,                 arm64_sonoma:  "3ad4816347d7d70a6515e1ceafba53e45667cc3a8d64d6cc2c8c618877a1a92a"
    sha256 cellar: :any,                 sonoma:        "08229e8b262cf7aef18b8786fbe5faf93b193f65ab449b34e4143331a119abf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49486ee0b11ff710a797b6e5d0b65e8e73f61794edd6dbf18a4b18d007c8bfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bfd0f754bdb31491671c540c2300e3b50ad0bf9f76ba5079627442b20f77230"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
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