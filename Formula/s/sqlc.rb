class Sqlc < Formula
  desc "Generate type safe Go from SQL"
  homepage "https:sqlc.dev"
  url "https:github.comsqlc-devsqlcarchiverefstagsv1.28.0.tar.gz"
  sha256 "0f7f6992855c487871d331443a7091e1a62a345968483b581b20a7259f557af3"
  license "MIT"
  head "https:github.comsqlc-devsqlc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caa8d51308aa6abf0dbd6acb6f353d1dd6648a9bcef289144a5bfcc68aae5051"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b39222f01fd18759f9eb377107e171b58f65cbef47c1cf15b23870f0b9db38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b777e107d47a905be13b907ac37b3a8bce4ee4e3454147f58b6bf8fd7d3a066"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bfe4bbbbb0aaa33911858cfe85b7eebf23f55e7768aa10fc2ad9218c711aa88"
    sha256 cellar: :any_skip_relocation, ventura:       "d3b2510595ff558f5c8433abb4728436e6e7263b0a78a703008f7c350e66351b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab99091241a87f58cbcc558e3dc820b60e916337cc7a78212e517841268f367"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdsqlc"

    generate_completions_from_executable(bin"sqlc", "completion")
  end

  test do
    (testpath"sqlc.json").write <<~JSON
      {
        "version": "1",
        "packages": [
          {
            "name": "db",
            "path": ".",
            "queries": "query.sql",
            "schema": "query.sql",
            "engine": "postgresql"
          }
        ]
      }
    JSON

    (testpath"query.sql").write <<~SQL
      CREATE TABLE foo (bar text);

      -- name: SelectFoo :many
      SELECT * FROM foo;
    SQL

    system bin"sqlc", "generate"
    assert_predicate testpath"db.go", :exist?
    assert_predicate testpath"models.go", :exist?
    assert_match " Code generated by sqlc. DO NOT EDIT.", File.read(testpath"query.sql.go")
  end
end