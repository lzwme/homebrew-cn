class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.8source.tar.gz"
  sha256 "6a308a0f6d9b0958eceb59a0df358a33d1cfdaa97f208d67d4a757a6835e3a2e"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4aad31f2851c4342202914058cad5eaf82e66d40027f4b3d735165cbd09a10f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68f321a443995503ceb816dfe9180d5d9be892cde227b63d337531de38b3a98c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9e2c4421cdfb7d68066ec0b1dff243c83243a30940a456d0af6b5d5ee6380ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "14af378f5f0bfb3bbe3e782d0ca2d139c265634f7b97c822b1c5b609a65a978e"
    sha256 cellar: :any_skip_relocation, ventura:        "f363c14eecef2c9ae1bf4ed833e438b953d58118776d6b0a0aa307920e2d79ef"
    sha256 cellar: :any_skip_relocation, monterey:       "e753004cf10ee8f47524535be18f2c334c18e1a72d1e8dcd5cd4dd73a282240f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6889372b0e7ef6770faf9494ac6a77310a7a71acafd6c8e73a4279381b051b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = fork { exec "#{bin}sqld" }
    sleep 2
    assert_predicate testpath"data.sqld", :exist?

    output = shell_output("#{bin}sqld dump --namespace default 2>&1")
    assert_match <<~EOS, output
      PRAGMA foreign_keys=OFF;
      BEGIN TRANSACTION;
      COMMIT;
    EOS

    assert_match version.to_s, shell_output("#{bin}sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end