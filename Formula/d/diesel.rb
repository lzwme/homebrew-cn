class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https:diesel.rs"
  url "https:github.comdiesel-rsdieselarchiverefstagsv2.2.3.tar.gz"
  sha256 "ce766358766f8593eb06c4a7fc67537195af8fadd690b9e5b1fb17f8b8507e44"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdiesel-rsdiesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23945896a706dc76c74b703c9b31be29bbec4a6d58e1bfb301904ad9d868a420"
    sha256 cellar: :any,                 arm64_ventura:  "621382044b546373c0469287e3bf8c4ce77e1939d1deb10e6423e4125f192957"
    sha256 cellar: :any,                 arm64_monterey: "9c7327274e0a4d3f9ffe6f010c2e4e283c08ff2d55ca8d995cdc8bfec9aa5e88"
    sha256 cellar: :any,                 sonoma:         "2ee3c7b9f8baae3c8e0321ee6159b8e5da8d26624ae3a94027f8919c1c45e8c8"
    sha256 cellar: :any,                 ventura:        "1e40f0943ddb581e4a79809c5226841be6596613e7f1351f826916f1d6172bf5"
    sha256 cellar: :any,                 monterey:       "2acdab2bdd2f584208e1d958f8ef3222bd8ccb3de0d3eedea5dc8b4015357e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e916d4214536e731d89de1e654f86dfdf82d2d40462b9b668cd89fd15e599a1"
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