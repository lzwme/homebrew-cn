class Sqlc < Formula
  desc "Generate type safe Go from SQL"
  homepage "https:sqlc.dev"
  url "https:github.comsqlc-devsqlcarchiverefstagsv1.27.0.tar.gz"
  sha256 "0ee0f9aae3d9fb9752e09b68ce0cde0532bb481565313aa2561638893b49544e"
  license "MIT"
  head "https:github.comsqlc-devsqlc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "77f9fab9c75c33c2685bd67e09448acf5a25795e74bce167858aa32c61dea523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c17ff31cdc2857ccb8ddb5839ffaa81592bfc83a66380bb339d80ddce3ebe39f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6627a3473a3d87b63daee1985f173a09949d30d3f74900283cfbf8d87a4cb7a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07d4d2eb9782426ec96503c06fbc726ac0fc6e6bc94ff1a29aa2987e203015df"
    sha256 cellar: :any_skip_relocation, sonoma:         "248fb388ad0e9e5f5f251bd9d6a3f06269b7acad9435c8b01b399b46ce486906"
    sha256 cellar: :any_skip_relocation, ventura:        "09b6a0bb1b035b6d1c659445ea5da72bb01e9860d0a6d3f7bdbf01059b9719ac"
    sha256 cellar: :any_skip_relocation, monterey:       "c6f86b995d4a2d714ff2dae4af8667984d634713bea019f523aad4cee93fdee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "345c914ba3bbaf9ce9403f1889ec60ca845a9d52faaf5f62f3c142cb61e3a2cb"
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