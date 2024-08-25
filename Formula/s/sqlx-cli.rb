class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https:github.comlaunchbadgesqlx"
  url "https:github.comlaunchbadgesqlxarchiverefstagsv0.8.1.tar.gz"
  sha256 "5a52c3c825bf2362bb021426a562b0563662eab399ca6dee8818d65d881bc8d8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f58211b78bc5a8f7584b9404abef19af8c188c8e8f999649a2d6637d6d9a72cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "818f2b4e57602f55088f1716289731ab33ae02e08170b50b49153ef3b6f10ca5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe72be906fc1393603f0f23c74ae2b01e747154ed6acb40892f8b129e92f8e05"
    sha256 cellar: :any_skip_relocation, sonoma:         "752b55d1cd364db1fbf182fa779c1f9c61ace9eaadb24b8bee10db41b3f18f31"
    sha256 cellar: :any_skip_relocation, ventura:        "7406edb609721cbbf07cb53687218c4bd8f800737bf79b7431cef9e179601b73"
    sha256 cellar: :any_skip_relocation, monterey:       "4b4fe6a76d63ec21296ba8eb2fd40a192b60a9be60b2bac72346b317ce1d144f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0831e771ebb2dcd44ea2d3b5a92d60930880c1abe024fe6a5d84a6e7ac19e3d7"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "sqlx-cli")
  end

  test do
    ENV["DATABASE_URL"] = "postgres:postgres@localhostmy_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}sqlx migrate info 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}sqlx --version")
  end
end