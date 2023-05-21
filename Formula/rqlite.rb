class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghproxy.com/https://github.com/rqlite/rqlite/archive/v7.18.1.tar.gz"
  sha256 "1d63b74b4ba91c8981aceed982f01c12df566d5b5ed2df0e736e2992154dde02"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a537340683e5872be8b6b6b9d04cba1ea8357298741a5b18ac4668e47885d507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2564bf683571952f2c62494e9e0e5072dcfb19b273f2a627cef849c4dabf156"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18e73cb2b714b4ead9bf28d8395e60301ce77db04992b66ce6aa75340be379ed"
    sha256 cellar: :any_skip_relocation, ventura:        "3839cbed681ee351f6fb7bef1b5baf62364fd7dbe5484cf4e94c850e2993a400"
    sha256 cellar: :any_skip_relocation, monterey:       "88095253f0d78a1625928cbc9f31bfd94378d7a7a9cc0f2ee2c906efb6a95a13"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd275ace9f21249ab4411747cd36aa9ef2a251f194885912bd7d9bb8570f8f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2858272cbe5c6c4302d750540e36f0c3fd084378f89bcd2c0678750282adcc4"
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