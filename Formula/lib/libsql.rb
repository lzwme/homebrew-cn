class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.16source.tar.gz"
  sha256 "da2e94f45476f6a20ecb02dc225c1ac7e0bfc750a5051acfe37a619be877ea58"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "871530534035244e2527208221bb83fd86af43596e32c55cf73db729ed946d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45cd2a6faac5dd8844f83aa7bd268b72f13c7bd332f1a51a604664a150ca272e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5336613ec7e665f4d763ce0cd895c97076f48ff4b379325f504d693d0a80051"
    sha256 cellar: :any_skip_relocation, sonoma:         "49e3d993b0f7fe35e5e3094f14c914f8343fab6d05b26d863deb0f3703f67d04"
    sha256 cellar: :any_skip_relocation, ventura:        "fa7679515438291b3985019745fb9cf080e16823e3638c71275eda935a2a1e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "16f6a44d107787106c5889dbd343b6bb7c47299388382fec5f46c4224c37c1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84c69209de3ab4e395950f4c96882458a9d6d4349c872fd3df3930c13977958"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = fork { exec "#{bin}sqld" }
    sleep 2
    assert_predicate testpath"data.sqld", :exist?

    assert_match version.to_s, shell_output("#{bin}sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end