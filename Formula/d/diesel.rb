class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://ghproxy.com/https://github.com/diesel-rs/diesel/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "5aac923078a5b431902d75cfca36f2990b3f11dbb2bbbc44f4538305af939657"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "608973741191ddce848c9cca40080a082b35e06f4bef4f0128ff42c045a0ca4f"
    sha256 cellar: :any,                 arm64_ventura:  "25ccc9d1151f4f0ebc5139537e5cd05e2bccfbf16f1d84182c55e464a8bed2b1"
    sha256 cellar: :any,                 arm64_monterey: "ca7d81596d9c941b7fede129bbd1f0870752fd48b779d2fac5e7eedbc6043422"
    sha256 cellar: :any,                 sonoma:         "e363f0af425f142c3a93bd2b2413d1da88904590b795cbc162478774b6dfbce1"
    sha256 cellar: :any,                 ventura:        "4317c4ae0dd0102cb3081c1f0e566de99433bb2bc70852106720a925551d1886"
    sha256 cellar: :any,                 monterey:       "f19abf8905c6ef8ee97e90907d5872af57d5b04d46f035c8f9e955144a05a15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "211c7444e7ff2692c71da7c20969fe17926de823c46e57be6222aecc7ee4a4d6"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args(path: "diesel_cli")
    generate_completions_from_executable(bin/"diesel", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end