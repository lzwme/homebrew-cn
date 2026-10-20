class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "31802536f03c67e699ad48504c76e0b3c9bfa576753db254271e96b354b0639c"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f733178b7026a1851aa05fb698e8fe40dcf5e83a4df8a9c1610fe458625d076"
    sha256 cellar: :any, arm64_tahoe:       "6ae5cf1da6c03b39df0d31235ba7bfc982e8d2f1d183b0710ac3a21c759bada4"
    sha256 cellar: :any, arm64_sequoia:     "b141c8177cd5b0b806a4526331ceee59d857353686cbe1561d9eefb439a8c072"
    sha256 cellar: :any, arm64_linux:       "03c6ce361c4f2efe08164124a02c9fcf8f7cc644370c4320ef6054cf9e894b3e"
    sha256 cellar: :any, x86_64_linux:      "2a4366cc4d21bb44108565c36a7d0d111f1baf8174f73a9d6d2aa9e0be77d950"
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