class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https:www.rqlite.io"
  url "https:github.comrqliterqlitearchiverefstagsv8.30.2.tar.gz"
  sha256 "a4c9ebd46efea08b3eb60020dc767cec072fdbb4e728714019d5f77995b25583"
  license "MIT"
  head "https:github.comrqliterqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3d167b45d6cc057a647429d9c5fe77b190b3b089d773c8d4180dfaf7b2fea04f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54ea1649ceda4b3123eb8bf6326076b46da361fbf8959b50a624a41900abaf23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95f7e8df356be61503c057b8799f61f818028a24aa73a40b68e86f7eb3ca5af0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "141bad5d515fc341dc8e2c01aa812f45063e2c8b1f3f1d90fb8ec464aa389dc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1926973b9b65744876bd7fbef536ef592f0e3644e4965d31ef5568ef2b74f4ba"
    sha256 cellar: :any_skip_relocation, ventura:        "178b3e0147ae000a92d90ec19f92c386e4b13b5b1e90f8d312cff5d7b730abee"
    sha256 cellar: :any_skip_relocation, monterey:       "674cee3587908e4ad09371fb41820ef8799b5ce8a79b95f2143cf8c7c9db48b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07d0d44d0b2aba00bbf89d8f0f728818df96a19242f4f1679b55f25735a91c6c"
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