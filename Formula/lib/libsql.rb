class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.12source.tar.gz"
  sha256 "4931bb84beafaeff08045a08d053830beba6d95997c1ad58ccbd03599a377b11"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3ebbc58aa5b0813ca1fb183d66c27af7304dc30046824111221552253c0bce9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66de5e00995d2e52f2718a382f392f7851934ea759f47be5a5c7f862519b1281"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e3e26991ccf08efc2060116ab9281deeb190f24d953678d35d6ecb38b316a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "04104e9cecabedf6285a5f9c31385cac19b08ed5cb6f6e5cc118e8fb09f91759"
    sha256 cellar: :any_skip_relocation, ventura:        "c1f571cacb865c34fb7a5d17ca624f8d266d00a41de7a2534b2c1eef6e3de272"
    sha256 cellar: :any_skip_relocation, monterey:       "99b3e7958ab90be76ea3ee65fe07c3254e598b5f14cff61c58ddd960ef5969f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5fe8e8dbb1c96de765ff4cc0f44a6d2207abd541d1bd40e4796425848f70e0b"
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