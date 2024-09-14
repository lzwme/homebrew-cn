class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.23source.tar.gz"
  sha256 "32da248b64c149fb742a3977002f45f8e5532d759af4e2802b70158a2bd024bc"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8fe6f5092133c17811b086a82f58fcdb22667ca3fb0b01872c42d36b1148b4c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e014288fdef773457d3d4e70686f02eb6603368138019c584b5f48479fde3aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74243f26b5bd01ac5cbc0c9b5a6c709de17a5fa6e8fc8ed3125d2414e8597982"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88003b2780d2cb8881ed6f7f8c1cb47a4757a5836c93101296ba6c17c262e5b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5b04293e2dfb66dfcce39ed66cea40dbb7cbf8148ced7de72b6ebb81ae0ed75"
    sha256 cellar: :any_skip_relocation, ventura:        "7e97d9ebbc2cedb8c81876506e8f866524c17edd665361d6d59352cb8e300803"
    sha256 cellar: :any_skip_relocation, monterey:       "95b087557148c40b33fb33b190b5338edfc4ca386a3b88181f74ad606d67517f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e01d762d3236bd81bc20586b45ad49fa4c500bd822085367df2a92d57537ed6d"
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