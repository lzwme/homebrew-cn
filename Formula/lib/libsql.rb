class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.17source.tar.gz"
  sha256 "499a24ee4b25f638f83a605a3395a1b895d5c7f1c017996e0a879a7e5c3000dd"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4595d7c9525194d636d7cee0dd64fd9b8c089ba5f7b55d6dcef3a4578c91892a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f784add436815d2b5257f2d1cd96bee03ba332508af9b192f0f64c4d0f5e099f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ad27749da72c5a070f9e8dfc9b9de461c1722efeb7c49407ae7a747472636b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "33d51609550fd7f705191ede0970055295f75a9c48141379ff27ded8a2e8151c"
    sha256 cellar: :any_skip_relocation, ventura:        "a61a3a95c42fb0b03d344401bc11a73d375c7c0bb9a34ec44295f7766a183ff8"
    sha256 cellar: :any_skip_relocation, monterey:       "8572fa5c52089faf31f70d53f512436696ff0cc75ef6fa7ba6bef42a0302edf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ec5180f20e91d0a409b4653d05afd6b6a87f47b2e2dcfcc534cfa68ab245c88"
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