class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "5b687ff68a1f6be864eb60ba4ce4a6f27f9d544ca285c3ce9d24ca6fca8a94ed"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5a0286b9f48c5c7e94d0204da64062d067903112bc46485ddff1389c72a8b1b3"
    sha256 cellar: :any, arm64_tahoe:       "d2e7d55d2ef57bf10b54d796306ab3a93a6d43c2a851db0a6f119a7a23135bcb"
    sha256 cellar: :any, arm64_sequoia:     "5e7f0a24f27bdceb94cd192885069db77fe5996ea3f6da45a4638c74e2d88d2f"
    sha256 cellar: :any, arm64_linux:       "f98cede1f370d4b65f795a7d238b40a2b7d1657eadc61514950b2925c2d67472"
    sha256 cellar: :any, x86_64_linux:      "c439e70c5dae438c1668ca11357c1e301f0fbdad82fbd00dd4fef301826f4245"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "openssl@4"
  depends_on "sqlcipher"
  depends_on "usage"

  on_linux do
    depends_on "aws-lc"
    depends_on "systemd" # libudev
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["AWS_LC_SYS_USE_SYSTEM"] = "1" if OS.linux?
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.mac?

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