class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://ghfast.top/https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "d66e7121b685d4d9d7b79c06fbc1b96634831f39d1662f75e231b6c0587ad76f"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d16d330aea8759d63d4b04ec19949afd49cd826d9c9a1e5be62446f425b6c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb4883fe6a14b1f4efc701d19b8c3ef285d666680a9599df952d5894a664fd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5401f607954df39c64c5b2a46ddb4aac0d6e9803691f1ffdbfc35656edd3c6f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d9bd91732b0b3fcfc44a4520743461bf3a479a0db522149d62e68ea6e419c80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "858927aea2f2500ee742e973c6380124ef2943278473f77bf66c1ff347fb2464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "012ccea8fa19883ecefe3ef8b1627f0e24ffce5e8bf46fb9d2387fb84176779d"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build pg_query

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"migrations/test.toml").write <<~TOML
      [[actions]]
      type = "create_table"
      name = "users"
      primary_key = ["id"]

        [[actions.columns]]
        name = "id"
        type = "INTEGER"
        generated = "ALWAYS AS IDENTITY"

        [[actions.columns]]
        name = "name"
        type = "TEXT"
    TOML

    assert_match "SET search_path TO migration_test",
      shell_output("#{bin}/reshape generate-schema-query")

    assert_match "Error: error connecting to server",
      shell_output("#{bin}/reshape migrate 2>&1", 1)
  end
end