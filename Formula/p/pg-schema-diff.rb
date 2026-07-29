class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://ghfast.top/https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "dabee566dd0f2ce2836d0dca6ad3a303261ec3a6e0064e599ed9a7c191ded95f"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7b70c37d5bfb98a6ee0694926a0c3226f29da9ed1af67ff0cd8562332ae3ad2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7b70c37d5bfb98a6ee0694926a0c3226f29da9ed1af67ff0cd8562332ae3ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7b70c37d5bfb98a6ee0694926a0c3226f29da9ed1af67ff0cd8562332ae3ad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "330424c4cd4a1646abf9465d58cc751916328ba7cb9490f011828190721bcdc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d6cfaa9e3ff26c89ab72bf5a04152c8b93f4c22a7430b949420dabde6d3b0ab"
    sha256 cellar: :any,                 x86_64_linux:  "d246fc586e6e3018c4a670489775dc62575966967a436a2e59c671068f1de9e2"
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