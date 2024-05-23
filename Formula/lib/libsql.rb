class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.9source.tar.gz"
  sha256 "afe29d4b93a584cd51735395adeaed01716d168c3435364c2e6c75fcf60eef9b"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "769668f205d94168de92a7e20facfa1f0b16ee8670beb460f52f10aff4e2ac9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7d30ecdde6ce4acca63967a93b6e26ee3fe84dfb0d4443d4cdc49bb080799b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a27e975bb8497cbb35a8eb32fb10bbe0193ef8f16b4c8442a14b398755a690e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c4a8a9c255961f1dc4c1b17ba708dfb82a51d207822b4bafe84628e4306dd13"
    sha256 cellar: :any_skip_relocation, ventura:        "5351c1db59b8f96828859e21b240d7549c946654d07b0310394667cb76c97d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "e94a9c52c011cdbf5e022584dc67c1afb1bdb5afe0d6d196919a8bf2c6037177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5989b7cc9bee67ab2a62d5e90f231f298af3255aaa09d525a06202913e8ce3e2"
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