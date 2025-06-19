class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https:diesel.rs"
  url "https:github.comdiesel-rsdieselarchiverefstagsv2.2.11.tar.gz"
  sha256 "d2fdb24e16b4a26775bf76833fbb410e97f68af1161a084a500bc79d8d06dc41"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdiesel-rsdiesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb6a01fc55d2b30f4d2dd947e2f9934b5d67c2406397a492e53e505e999cd504"
    sha256 cellar: :any,                 arm64_sonoma:  "0c27438c7e7447f71682a2e4f4cbb08a84ae87f839e2dc1be8c8fd1b695c3125"
    sha256 cellar: :any,                 arm64_ventura: "5f395b3ba120fd233e54ffe42b3e5efc26d73228da0949072157b9f52f219a70"
    sha256 cellar: :any,                 sonoma:        "c35dcd4b4230fe8555b94fe1af19af0340462ee16dc770456e968bdcd4c8ba25"
    sha256 cellar: :any,                 ventura:       "7e165c1532d958faacd270bd95232d7292b39c012efcae841517b19a2686ca5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62c344e2970dd86c0e93be0ee74090151190340564007f4ade0039000103e9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d030c73d1939f426b46f165faa1f454e74993c0fc68a4262d55abd864ed685b8"
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
    assert_path_exists testpath"db.sqlite", "SQLite database should be created"
  end
end