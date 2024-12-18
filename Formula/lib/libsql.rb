class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.30source.tar.gz"
  sha256 "b9334866c74103056747753f940c8e597e78b1ab131c1fe37e5d865b4ca2ea8b"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e9cbc4f225acc77fac83e2a5275bf8f48ce86988edd2bccc9b30373d6d110f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c4794b74e1c41e859289271eace0b3fb60eb29086468e3367a0c1241ad6bbf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ada14220d7002aed4310020bdf638aafce9329498c7fb9550c4302668ba2e4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1daa2443761f4516c8faaa022593e614b20b9ee3049490f9adad14165505ac53"
    sha256 cellar: :any_skip_relocation, ventura:       "68dc549401fb4ec2554ff9c73bf3bf52e9c5e84d5ba19827fdbee40c740739bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f6e124b4760218f51e22f37d47c4fe876182e6e37f4c5ea8bab872994b4404"
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