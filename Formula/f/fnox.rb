class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "9adb4cf17095f9ba7408f370923d877d419eaffbd9ca1a3843212e0ccd6e173f"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2b6fee3a91d738f5c296355e9e1dfe72e70ea09890f4ddd6db1f90d081c2a003"
    sha256 cellar: :any, arm64_tahoe:       "fde37026bda56c77d485f13c89cb9b4c67c2979468401d30da17625e479d71a0"
    sha256 cellar: :any, arm64_sequoia:     "3a3e1fbe8c49cdb98ea1d42dea86d8f91bd609ac548f95e0c863c5d467d0e3e1"
    sha256 cellar: :any, arm64_linux:       "1cf7bb27a90485a3138af338745c16350a71ee7d999e332e11afde85b3231d0a"
    sha256 cellar: :any, x86_64_linux:      "0d4e592f9582e2454a05635c59d02203bf7f2a87f17d04b5eea46c3376b1ccc4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "openssl@3"
  depends_on "usage"

  on_linux do
    depends_on "systemd" # libudev
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fnox --version")

    test_key = shell_output("age-keygen")
    test_key_line = test_key.lines.grep(/^# public key:/).first.sub(/^# public key: /, "").strip
    secret_key_line = test_key.lines.grep(/^AGE-SECRET-KEY-/).first.strip

    (testpath/"fnox.toml").write <<~TOML
      [providers]
      age = { type = "age", recipients = ["#{test_key_line}"] }
    TOML

    ENV["FNOX_AGE_KEY"] = secret_key_line
    system bin/"fnox", "set", "TEST_SECRET", "test-secret-value", "--provider", "age"
    assert_match "TEST_SECRET", shell_output("#{bin}/fnox list")
    assert_match "test-secret-value", shell_output("#{bin}/fnox get TEST_SECRET")
  end
end