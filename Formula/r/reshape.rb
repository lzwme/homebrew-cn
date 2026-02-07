class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://ghfast.top/https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "f9acbc3bbe31d5289d040082bdabe9ed1460728821a2d277374214a5a312b301"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb4c920635d4bf6b222b437aa789fc4b37e827b8d282fb949ac76427a05d4a97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cad51c012ac44e0a9badbd77fdc2d661feb9872ed7a57271e72024ba3f01d2f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364c043cc764376f2703119270dce0a5a6cb9ff3d065578cf98e3a157b29749d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5da5fbcf2603a9ae24e70daf7588c2388eca8697c0b8a201755d04780e98729"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f763f05a00f763b36b3580d49d1b768d8de7d7b35cf0bc466780c871d1fb91b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5a0e8515fa424eaa98a07fbcff6c145833dcff2d3fe3833c1030a55f71b3fc"
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