class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://ghfast.top/https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "ff282cfeeaa3af3677cd421a6eb9c9c406692f1961caef2a40870c54771e63ae"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80b941332316ea7d3100f035eb73f93e987bdf603d48e776d4df6c93637355b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b941332316ea7d3100f035eb73f93e987bdf603d48e776d4df6c93637355b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80b941332316ea7d3100f035eb73f93e987bdf603d48e776d4df6c93637355b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "78916fd8c370f69e7790f3958d89042da367e500309953885784a119fc08195d"
    sha256 cellar: :any_skip_relocation, ventura:       "78916fd8c370f69e7790f3958d89042da367e500309953885784a119fc08195d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5ce2f0a351987bd82e28ae72a6d1fd80da5d31a2fd207333930d3af5beab63"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pg-schema-diff"

    generate_completions_from_executable(bin/"pg-schema-diff", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    pg_port = free_port
    dsn = "postgres://postgres:postgres@127.0.0.1:#{pg_port}/postgres?sslmode=disable"

    output = shell_output("#{bin}/pg-schema-diff plan --from-dsn '#{dsn}' --to-dir #{testpath} 2>&1", 1)
    assert_match "Error: creating temp db factory", output
  end
end