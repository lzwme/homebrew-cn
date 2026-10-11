class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "21669929b2517e7b5425263c75c5f055220126cac1720b40549c316c92db77a9"
  license "MIT"
  revision 1
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7e634880bb6086d437e0cf3ff5389db279d46ed6458ab66e9629849babbbc6d2"
    sha256 cellar: :any, arm64_tahoe:       "68992fc04475d20ef800954ae98573232860c32a7d28b285663bbe45ce91b102"
    sha256 cellar: :any, arm64_sequoia:     "5a8accba03935e73b28162736139436cb0683227215ea02efd16e142f3507e08"
    sha256 cellar: :any, arm64_linux:       "e3e1f1abab3f82bea47a38a9d80b50dd9ed336f7ec40f0b7f2efc0c983bfdde4"
    sha256 cellar: :any, x86_64_linux:      "a4a18e2b471a48939fa48dbae70c7a48368dbb8a0958989fc6330a8ea6ae8ab2"
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