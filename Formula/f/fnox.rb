class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "62161159a07debe06d22425e51ee368b10ee6ea4b3688866f9a652c75342cc96"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dddd24f2aeb9681ddfb036f7360180f9b1a242ba4273df81d66909f06e5f9b08"
    sha256 cellar: :any, arm64_tahoe:       "93455bdead213cef32fe2abb9b5cb225dfde77a553325d8baade9254d49f122b"
    sha256 cellar: :any, arm64_sequoia:     "252f56d4fd71a2139a21fb21d843d0506f814ddba0b2cbd399f8db73e0429fac"
    sha256 cellar: :any, arm64_linux:       "03effabff1fd6e647723cbe940a5c1e2031e40643825f3e35fbfa8476e0c53fc"
    sha256 cellar: :any, x86_64_linux:      "ef8cd7f1e0c84b5c3a84e726a6934fc5350badc0dd0b5e179e3e83701557d568"
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