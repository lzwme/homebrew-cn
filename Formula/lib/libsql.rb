class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.15source.tar.gz"
  sha256 "84348884e969c66564fd1379f269eafa0fe68248e7eb5b0667b2a7bc9c93e86c"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "174e85a2bca7266ec73d0eb8e8f1080103e9d21be7585ca0d91e4972d8c28e40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00d18b5455ac82664924898805534a5abfb3ed59996cd415ef1a1b9f9eba1195"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e50f39b9aad858abdd4058971f99dc52b1f5c96591bceed4155e5d9cb7ac89"
    sha256 cellar: :any_skip_relocation, sonoma:         "c562058848a6c6cec16ef2300364ebb8d22f4eaad9042092c192901891782b52"
    sha256 cellar: :any_skip_relocation, ventura:        "0a16712f72675261d0e8e5cd3f76196737044a8b7b05fca3bd0e186806bee6fa"
    sha256 cellar: :any_skip_relocation, monterey:       "7753363cc376a006b910035f6af795e1f8e3ab08629289267be4a1a4f0636e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65a9f6f337dc3c4deb4856a8770a0cb677ef0bfe88cb50df0052fc41bb709310"
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