class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "00e2f72a360dbb5e6ebbc3e469eacf98eb48b7ebb18104bf934cdad45779f751"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7419e9c741b009748b7394f7e49dcf4324231c445a338d3c3cbb35ed5c152d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cecfb9b84c3c2eff0d9cf484ce0a5f18e58a34ced98f2ed90c6aeca840c7831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb222c72da83404da0181e41221311e66a6d740682df94a773cd0fc637c3ebef"
    sha256 cellar: :any_skip_relocation, sonoma:        "1699674138cf5432aca251286a63e939320c27eff9bd7a01c95b9120dc17240f"
    sha256 cellar: :any,                 arm64_linux:   "3964b1a1f88d39b5a7df9a837abd4477872830dbe2c612252fd187020dbab422"
    sha256 cellar: :any,                 x86_64_linux:  "fa6d863f4ad8b229cbda5b4d3ee8065edf1bd09ac9b77c06a97bb386ac4d719c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "usage"

  on_linux do
    depends_on "openssl@3"
    depends_on "systemd" # libudev
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