class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https:github.comlaunchbadgesqlx"
  url "https:github.comlaunchbadgesqlxarchiverefstagsv0.8.2.tar.gz"
  sha256 "89fc875ac233e25cb8da18d581f28a097e419949d0af876aab143ba620852ea9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52373a6a9a45d43817bf4c659cbec4788b9a44705807006edcfed4dc7651a7eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "301e1889869918cd21817740ca7b97ace318b70b36706401c447aed3759152dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "faf3fa9c8d12dd0dec06913723dd16efdde46541c1c908940f502b48d9b2a141"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5b32adbf84dabff3868ec62c2a4af80e0e50b9e410ffd0a59dbdaa37f973f10"
    sha256 cellar: :any_skip_relocation, ventura:       "2636cc4d63867d085dd502f33b49eef770c1bcf820db0dccde56b701adb559a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aecd28cad32990c6bcd43a198bbe6e2da55029c0b1cafed4ff25b3edec0349a4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "sqlx-cli")

    generate_completions_from_executable(bin"sqlx", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "postgres:postgres@localhostmy_database"
    output = shell_output("#{bin}sqlx migrate info 2>&1", 1)
    assert_match "error: while resolving migrations: No such file or directory", output

    assert_match version.to_s, shell_output("#{bin}sqlx --version")
  end
end