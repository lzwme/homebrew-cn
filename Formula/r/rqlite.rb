class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.12.3.tar.gz"
  sha256 "8bcccf41217436bb55cb9865991b58a83b03985c076f6260d9daed46f1e86c93"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0b6bca3658872220812f32575bdab0cd68070460144b148aee5892054153642"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ded18a8481a85e75841d3f0270408e990ed4a6287f4e840075a781fc8448b8a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b1aab53a807e5ed0c3738edbce0a2810f3670b37e93789495bda47493c593e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ced770c94408f246f8847f25e99efe653217b6b90dd9bbc6d6f17f0f09734ad4"
    sha256 cellar: :any_skip_relocation, ventura:        "d3052e4eb912ddf72d3c733a585bc45e720f80db2d1a88d6ce2bf44a37ef9359"
    sha256 cellar: :any_skip_relocation, monterey:       "4c62107936aefd43d259db5eada2ae2cca216cc80b95cd82269d404d4a43ca70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4346071be6081c4180a839e40ccd6ae1fb09dd03b96902b51c5a48c57e83a73"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bincmd, ".cmd#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statementssec", output
  end
end