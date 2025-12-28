class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://ghfast.top/https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "036abefc48a7c4b3fe73f8ab659f7d3f3379d85b3747cd2ceb973ae542192667"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "085c2bfe11972fb0922360499fd8d793facfe28817ec2313e58e1a1bbc97bb88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "085c2bfe11972fb0922360499fd8d793facfe28817ec2313e58e1a1bbc97bb88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "085c2bfe11972fb0922360499fd8d793facfe28817ec2313e58e1a1bbc97bb88"
    sha256 cellar: :any_skip_relocation, sonoma:        "df336065efeb7b0b6abc02aac40e002453c508c0ff9bf5c09c178a0bd84776e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e1513230bb955ddb5bbf5fda5f89606d07477fdb250861ccafb1eac6f98fa6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d838eb7eecf2559d9e7e53f91eddc1e62011a444648ed5e3f927cc4518be244"
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