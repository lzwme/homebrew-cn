class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.28.1.tar.gz"
  sha256 "43b05dedbd786c9d6738959647ee3774ec3c621b1f64c1329b58ffcdc949130d"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "641eab84aca7c60a9c156b72d420ae98a9670399065d752e27e5321a93a89621"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9af0659dbe04471c72d393e18b01fbada54dbdc57bc5f16b42c920f863dab46b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee9ea38fbc99cad52e354087839e77528128e415e2495f019429536bda146b58"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1319a8608ecdce468fcd6b7181edc05f7cf25c132a92dd5c8ae95bdf798b6cb"
    sha256 cellar: :any_skip_relocation, ventura:        "c2a192eb49c33e68d8636f44a3f4f3f29a80edaf858a68d8fcf8d33428b130c9"
    sha256 cellar: :any_skip_relocation, monterey:       "10009de0f879ba860d2ed8a9e486d4962a2d5c947aad7a76c0b20ef2fa4d3546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea76169741ceba75146f0d964b8d38f965a7e50169d3c48fe1d19ca21eb3c963"
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