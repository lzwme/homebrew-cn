class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.26source.tar.gz"
  sha256 "6755463f25a08d0ede7124cb160810210ef15ed95b9f11cb2fb9ea8b64f425a1"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33768b73d75f7645b8be5ebd99abd891f65b24c211b6def41d15a2943576fa60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3cc9874896e737b4072356666e4f0f43a3d5ae146086416dee5d1308bedf4a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3c2c492a9771ba52423249ccfd8450100a6d25c1a23f53b1f7c1c8c36fca0b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbc062f022409113fc3f6f31d98b2e01609efccbd9ebf607e49cb37a2a66ef29"
    sha256 cellar: :any_skip_relocation, ventura:       "542552687a873a9134a9196743e966ffdac7e37fa84e1e4cb0305262bb88779e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a77401d666b661cb14e481eb78dbbb7d68648ef18c1446dcdeae780489f61c"
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