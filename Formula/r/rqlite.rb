class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.26.3.tar.gz"
  sha256 "e2cbbe8c366146e174ca89a764c864bc53c3bfa18f99d3453a798c246fb7584d"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ceb9f83f723e54ae6c42dc4d7b5895029c27a05658cf4c15a793ad2a17e6a554"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a724876cfe569a7c5f76cd7ac41071898cd818ff4ab24e874e3fc45978772a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0764501c570e5ca2ed97c6b5ab0706307fa405ad3ccc1ce92b7d531931b363d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c75c198fd7bf5ed3c0c480327c293a06fc040c1f897f00b42240e528c5d4379"
    sha256 cellar: :any_skip_relocation, ventura:        "10441fc8e55cfaae104c4570073f20ce8f8b9746a52f2af2d058c28e73f15c31"
    sha256 cellar: :any_skip_relocation, monterey:       "3adb462e83de3d7b79f05aadca31d9e13f9996027a07cbf98ca09a011a222154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab71d6a473b9c184c97e74ce6437f1cbe888cca8cd7e2c5fd4edb8de450e20b5"
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