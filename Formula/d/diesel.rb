class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https:diesel.rs"
  url "https:github.comdiesel-rsdieselarchiverefstagsv2.2.4.tar.gz"
  sha256 "519e761055dea9abf6172b8ec15c0fd0da53c859e6b6809daeb104bbecd6fe57"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https:github.comdiesel-rsdiesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0901df8acb9ccfba1784db14f3c5dc79df2a6c6843aaa0936275d4f185076ca7"
    sha256 cellar: :any,                 arm64_sonoma:  "fa7ef403349a05852da68bc8977e8704ace5f3af3d461b6eefe99963a0f5c019"
    sha256 cellar: :any,                 arm64_ventura: "11ca7c015cd6911a5483800606d47db6b1203391079498d8418f97ba1a575fdc"
    sha256 cellar: :any,                 sonoma:        "04bb398d544d79dd47a4c5bd255e7fe11abc7892fb35c3b2a44d5200fd3ed45e"
    sha256 cellar: :any,                 ventura:       "d0b1a014350e07498bca6fe3cbc47c387e02de04645a9e3b9a5703632329a55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "719172aeb95db6caf68f932878b6f091f3f182de49e33e8062f73f864d7d60b2"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mariadb-connector-c"

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args(path: "diesel_cli")
    generate_completions_from_executable(bin"diesel", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin"diesel", "setup"
    assert_predicate testpath"db.sqlite", :exist?, "SQLite database should be created"
  end
end