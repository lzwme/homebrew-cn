class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https:diesel.rs"
  url "https:github.comdiesel-rsdieselarchiverefstagsv2.2.5.tar.gz"
  sha256 "deb8daf3e162bb8f47f1c4a99c79e3c00827cc560b734664c434eab567b329fc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdiesel-rsdiesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a3a1a1647409c20adfb8b86f63d8e9cca7830826c7eb82f59535965648caca9"
    sha256 cellar: :any,                 arm64_sonoma:  "cfcddc0b4f9ca49c2cef14b5f4f0a39649c906148adb1fdae40412dadb391e0b"
    sha256 cellar: :any,                 arm64_ventura: "0680d239f9af79b14f621f051c2bb5c1bfb071d3fd5b99104c41869c26276953"
    sha256 cellar: :any,                 sonoma:        "4607272232505cc46822bcc665918606534a4065edd6451a292929b8da3b9f0a"
    sha256 cellar: :any,                 ventura:       "aa7ef5fd1ea981518ca846cbaa1f286f616251410a03561d428da837a4d6740e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9843ce843036bb706aafff3297c67d4bb1a495b3d534dc2ee272e0fe75c0ed82"
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