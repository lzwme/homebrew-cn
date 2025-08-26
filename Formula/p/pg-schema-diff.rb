class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://ghfast.top/https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cb9ed31378e8b68864978975376d3bbb33f438d7747a114d00a2478dcae89dc0"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b52583156ba63fd768aca26c12bbc5a3db5c9f2bf32da24fb544c35ee0f5e207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b52583156ba63fd768aca26c12bbc5a3db5c9f2bf32da24fb544c35ee0f5e207"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b52583156ba63fd768aca26c12bbc5a3db5c9f2bf32da24fb544c35ee0f5e207"
    sha256 cellar: :any_skip_relocation, sonoma:        "186ce18c2edfc82f4fa82645ebc88dc04d918a9ab86c501f0a376d34119dedb4"
    sha256 cellar: :any_skip_relocation, ventura:       "186ce18c2edfc82f4fa82645ebc88dc04d918a9ab86c501f0a376d34119dedb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13ac73b865e90a83a2d628001e799a94ab1f48ed63e0dbfb864114f0c89170a2"
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