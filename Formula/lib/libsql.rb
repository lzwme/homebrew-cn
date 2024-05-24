class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.11source.tar.gz"
  sha256 "bcb4780d75f88383f9d9e4e9ede2ae9b04e87ca4e0c2055176abcaa7d1ed2922"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c37d4244c3c26125aa7efce92468a3edac6cfeedac567c0dff797d874e4bf85a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa8c1be2b1ba91e04bd0c6b049b57f5b292c917525a2623f4c070c1cac7890f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47db47ade96e42c36ae15d4b9eea6d8f42a814b2a32df62aa13532ffeff32e3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1b83309472a0b804f2efac48f15b4b0e049c9ca2879f6fbaee295c7b28b24eb"
    sha256 cellar: :any_skip_relocation, ventura:        "542544c2e413e158259d2ba3a08ea2db96f8385ec91cb38080ba59b8f32503f0"
    sha256 cellar: :any_skip_relocation, monterey:       "ff68f11971a870a00ba27cde90e3b9c546ef59066b5a5ade4394ef66e5f2f458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79d974dd0c85a60ac2af2a44a98c3f60046096ea104899b032426b92e4b2ca5c"
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