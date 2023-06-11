class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/v7.20.2.tar.gz"
  sha256 "fe496f4b5b9ab952cac35d7edd19d1d45c4695de8c1cdfc13e9214b661f53532"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b1f76d2be4bad48c2ad89bfa56a9da99f6230a1ea888053233a0138a96e92e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65ffb1c73bedb740ba98f7196e51d31e5cbe371da43be02909015fc209cec4b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "077b0931c96387fe0fe5e537be67eac4d185142f8e12b66c16e3819d52ea71eb"
    sha256 cellar: :any_skip_relocation, ventura:        "ec22b94c4be4c1058548295f1e29775063ac30751cd99ca0c77fd4bb01c1900a"
    sha256 cellar: :any_skip_relocation, monterey:       "ddbf763deba9c29f9db0051c4340125bccae499c617c0bb2ffe2e12c06f461ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b985c01fbb5f17ccb88e492a27e9c7ccb3ead536d4e183afae5705af43bf151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338c9a824e59b254437ef6efbfa39977be89e3730d513ded8fb9fa2e84353d8d"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end