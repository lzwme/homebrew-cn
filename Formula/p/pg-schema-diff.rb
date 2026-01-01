class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://ghfast.top/https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c8788c2f585bdffc4a675ae0142527639ddbb06aea712e071aa19bd428580368"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b6ff6ea3b1582725490318bcc4ef93de99478bae2b785b8c75c3054c35240f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b6ff6ea3b1582725490318bcc4ef93de99478bae2b785b8c75c3054c35240f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b6ff6ea3b1582725490318bcc4ef93de99478bae2b785b8c75c3054c35240f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ac6edbc78af58d94183f0aa702a479a15d2669dcc85df0991601d9ee6f1e7ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e0062c12adb5e291e199c622c97dd0a9b6110fec7e6ef104501bc66ff938e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e91952886767253733af27e1d64f2bba199874476f9b76cc797fbc6c28ddedb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pg-schema-diff"

    generate_completions_from_executable(bin/"pg-schema-diff", shell_parameter_format: :cobra)
  end

  test do
    pg_port = free_port
    dsn = "postgres://postgres:postgres@127.0.0.1:#{pg_port}/postgres?sslmode=disable"

    output = shell_output("#{bin}/pg-schema-diff plan --from-dsn '#{dsn}' --to-dir #{testpath} 2>&1", 1)
    assert_match "Error: creating temp db factory", output
  end
end