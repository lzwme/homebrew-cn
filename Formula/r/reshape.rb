class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://ghfast.top/https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "66b825c3de2036277a9427200e61958ccefb7070158236694492afb25c83bdfa"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "755982c8fa337cf15a77a1b5723617408aafa43a22b2c0720b7c11b94a8fd07d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bd874df3958c4a6235b88ad164df8279e5425e6399d5a2696f2126a4fb6aa70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d07687b2f2061a64e6d53a8902fcd7dd9ae3d5724cafe092ad4a3f32efac3a"
    sha256 cellar: :any,                 arm64_linux:   "97a06a67790ec9cc51a4ff895136baf5df664cc31b7362a92a92d76ed8ab9f88"
    sha256 cellar: :any,                 x86_64_linux:  "74c05763735eb61035ebcba4245221113cfaeacf13180d5bb16ef27e2de0f622"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build pg_query

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
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