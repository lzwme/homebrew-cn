class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://ghfast.top/https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e18d64c8d7a093e45e829354ad8cf24ffbd6d2d6a1ae7b45471145264cb4bcff"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0483e216223d820bbdc4cb94c3ef5b1fb7fac2812e89eb7859feb851048dbfe3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e2507ba15bb6e31c6556cc3c9e5d33d8b9c010d6e84acf375956a6f5d266bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73680127359be8de1469b82e303431060e8e91933e4cc2a8909e3ee32eed5514"
    sha256 cellar: :any_skip_relocation, sonoma:        "5af2cc8c9db1119618463bd4e70ac0a4caa78f526b05c808ba10b041fe07e9b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c290f80b51e2645e7f08236d641c155ae0303e625bd781cdefac545d06534b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0c836aadca352d56ac386436c9f4c3cbad3e088fce3c87c19d5d9aa63d465be"
  end

  depends_on "rust" => :build

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