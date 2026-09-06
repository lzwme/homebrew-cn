class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "fcb87bc1b1b6bd7b1ce54d9c37f2278e39cc36abf3c2fa98fd5fd0b2081ab122"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84a42ab987d3ad7874f6ad7bcbf3a28369c7608c48d03a0ab485adc477004cbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a7466dbe3de48ee1f663b4f0a2261bdb146332c380b72dc2ce8ddbea2aad635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7dba74e583e4229aa56f9de27a2684956086834072c73d275f8d0902e22366"
    sha256 cellar: :any,                 arm64_linux:   "2db33f3a841df86c173d6ec82732ef0a4ca0caad5289e3763460b08dfefa43e3"
    sha256 cellar: :any,                 x86_64_linux:  "cfbb702a3de75015e091dd97a9955fe0b3b9745b7defe297fe2585cec2452238"
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