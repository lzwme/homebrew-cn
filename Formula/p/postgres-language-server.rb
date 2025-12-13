class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.18.0.tar.gz"
  sha256 "e40dbf0301ea345e18885b0710187f08bcad2e3426f3b24181b8efc8cb357929"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "808ce1a065846d485cfde6768b9202d2b796dd432956d210d9dcbb835a96f5d2"
    sha256 cellar: :any,                 arm64_sequoia: "412371bd5103e0e9b84274293acf1f2b02d083c0c841f86acdf72dfb8375f16f"
    sha256 cellar: :any,                 arm64_sonoma:  "01f3f72b15ef63ebf85bfce55f8421621652d6db5d514a478ac8595ad5bfb86e"
    sha256 cellar: :any,                 sonoma:        "01d472163303523e665de735619343903616eb3ae41e0801acdc9a9188c79029"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dafe71a0c6a22af822da3fb7395e445a3041a66db78620c4c33a4b9ec27c16a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdea69ce188c1b38f7f423597e17eecd2665142a87acd3304aee4a9e048fea86"
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