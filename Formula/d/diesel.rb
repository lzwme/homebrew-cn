class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https:diesel.rs"
  url "https:github.comdiesel-rsdieselarchiverefstagsv2.2.2.tar.gz"
  sha256 "322d38d41077d393877afcff02f7ee3078ec2ffbe284af8a8a807d015f6efa9d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdiesel-rsdiesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3c7409c1c40e2f3468f5dce9c1e8e040811f95aa562886bb9748150a90e8113d"
    sha256 cellar: :any,                 arm64_ventura:  "9a93cea52d38a24e9835380a6e7856d12e330197f87cf8177103b00bf6038650"
    sha256 cellar: :any,                 arm64_monterey: "374165fa4662076c58195c54995a14f50d53671758f47e151f2092ed400bab38"
    sha256 cellar: :any,                 sonoma:         "ece94a62580d49d6a1ce2f90b77a1eecbf116d917d92ac546d8ff772c5606ece"
    sha256 cellar: :any,                 ventura:        "629776dbacef4d400f74404960a5b9ba17ac9e2d9f52870eddecac54294656fd"
    sha256 cellar: :any,                 monterey:       "4b55d99579327168796571bef31ebc635d12fd9f8771af2567526e36e948344e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60a4b869610c0560275722d8b13b7b1ede6030a37d3405a635941278e7d04ae2"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

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