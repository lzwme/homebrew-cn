class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.17.0.tar.gz"
  sha256 "9e2e261098fe3d818c540bd3ba4c35b1034939b65a4b293195360062171403e2"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75054bca9e4f756eae4d892bb10535bef4945f1e8faa880d032eb8faac985b82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56fa8364886f26dcfeafe39dcdb8e9d94cad21b7fe0a79bd033a267b3aa646d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ad132c0c76a96c053c1fe2e643771dd8d57eacd07fd61cde26f9654561d4181"
    sha256 cellar: :any_skip_relocation, sonoma:         "a109121dc510072321756462545b812a6beb488080c9f97e698711f4f0e3545d"
    sha256 cellar: :any_skip_relocation, ventura:        "f3a0cf06fd0e13553c1bdbbf9ad0ac1243c2f6d6efc1c950008024f3efa0b521"
    sha256 cellar: :any_skip_relocation, monterey:       "03d7f25b5a88a0262e9d4374cfab9973d5ce298ebf609626445f538df941be6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45abbe84b269bc2f4277e8a4671332ca321e412e31e69f4cf8f0014fd27e7471"
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