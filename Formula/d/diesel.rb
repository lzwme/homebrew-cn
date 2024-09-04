class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https:diesel.rs"
  url "https:github.comdiesel-rsdieselarchiverefstagsv2.2.4.tar.gz"
  sha256 "519e761055dea9abf6172b8ec15c0fd0da53c859e6b6809daeb104bbecd6fe57"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdiesel-rsdiesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ea36a6c69e547713f98a97330b279be69d5b690f6c7d30321959aa6980bf79f"
    sha256 cellar: :any,                 arm64_ventura:  "25379aa34259c1206b1daf2ff9c9d9e1c2967ed203e30d3263e8739de1ef483a"
    sha256 cellar: :any,                 arm64_monterey: "ae2e11d241fd659c0533a66635a80ac5d567204fe15c0409bc1e8ec9a40bbb28"
    sha256 cellar: :any,                 sonoma:         "0684d4df055decc78dc9b03fec322563cba6b9d2907a06fff9814471b2dc787a"
    sha256 cellar: :any,                 ventura:        "d06ba8dd2ac936674894e98d8fd4d850be45c46707ee086e1d53dc0ad73b3d0b"
    sha256 cellar: :any,                 monterey:       "8df05adc2ac176b7bc38cb6a660b8853ee707ac9acff7d99dff7a259d950326a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d472ce4cf117dd30da2695aa8001a99f73ff10abaf7f99620c8f953e84c40ea5"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client@8.4"

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