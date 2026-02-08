class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.20.0.tar.gz"
  sha256 "fd45252e0c73fc8e0f75b0b47b28ef727572abe956edc41d7d0c149c0d4e237b"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5fe94edfd93173ce71d6407ca325c4e35504a86c49d8fa7b01899ef062d3596"
    sha256 cellar: :any,                 arm64_sequoia: "bed99e1f1ea5378da283dc2c0d230f4fbe565bd122f73e15ffd8c472650e6ee0"
    sha256 cellar: :any,                 arm64_sonoma:  "c87568e5e139c170917e6f94bdc7d410e061d7fa81a7a4374cec3396c8de830c"
    sha256 cellar: :any,                 sonoma:        "d3191da6a6e49947e9dec7939b2e4de15d033d331dbab154eb7bd0e4b865fa59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90ca09a5804d6f5b1133be86581b1d1bfd97314a0fef861f357006a54b001307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2400c084759400cff42a4a06b64955b16141275e50e7e35472d32f0d6cd5bc3"
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