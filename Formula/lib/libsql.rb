class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.28source.tar.gz"
  sha256 "35ce5a33f78e541e8aca7129eb874c923054db0b0ab91cb6401b6ce46a70a569"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b611be3d34168f7f72d6c953af92ad3962f0975d3b1f2aece78c46b92339a9fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfeaf29ba02bd1ae0a1c70bba9fc464f5c414ae5a4f7b6a985804129e05f7737"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88896a0ad27b35143f85deaa8fc5e4fb758f929bdbd12b7a534c2dac4695ba0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "efba34c781bcd872db8c8932d0842914e2c622b9135634bfa9ea0db968eab05a"
    sha256 cellar: :any_skip_relocation, ventura:       "63772283664ff6ae871cb341c9525e1e276b1aaa606ac4b4f09c26c290aeaf7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "526df599f5d5e2e99994386556b02dcf2625224391bc6c20ec0e1b3dfdd5905d"
  end

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = spawn(bin"sqld")
    sleep 2
    assert_predicate testpath"data.sqld", :exist?

    assert_match version.to_s, shell_output("#{bin}sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end