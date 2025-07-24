class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://ghfast.top/https://github.com/rqlite/rqlite/archive/refs/tags/v8.41.0.tar.gz"
  sha256 "31870eab4d0aba12d1bc4fe7a13c35859d78bc16c96d596cadadc0c382d3da47"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ce0a623fe0bd44ced7b1e7b277c2f8271f36365e896c5ac590113e03a940a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba541262efed5b26a3374f57a22fd14ab4a57f2d952173c581e55b1887724962"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e6053a6bcaf054b480b3beace6ecc68c45079a1cd880190d4b78fd9a93fd176"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5084660fd372d7250cdecb610ce9e5c78ed8e68efd8fc319e78052e00fd7cea"
    sha256 cellar: :any_skip_relocation, ventura:       "55a2bb99da125f83f5c27f509fad7b94a4d1b4d74c70948ff4751863fd1f59ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4378894f8038cae808d77140e9fb1b8eba18b5c209cacb4d457066768e6e786"
  end

  depends_on "go" => :build

  def install
    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}/cmd.Commit=unknown
      #{version_ldflag_prefix}/cmd.Branch=master
      #{version_ldflag_prefix}/cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}/cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bin/cmd, "./cmd/#{cmd}"
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

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end