class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "d1992d1b2d2042794dc1763f9d24d286d3a42f8cf190607d61cd6df6ca619fc9"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2cd88f8bea9ee310015fd3fe11ef6bbfb3735c41a09a63d4f6b6c852285e90a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d926dc4b017fd4ac1ac97431b095ff87871ffa5dec9bd873bb8e864d34ee99fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47b04f53b1c4c9e36534cf297633c6ba8385c23659f30a440135c79d23ea0636"
    sha256 cellar: :any_skip_relocation, sonoma:        "0761c947a0f7714195af63adee3f162d7046ad62b70656ad42ea944af99a6538"
    sha256 cellar: :any,                 arm64_linux:   "05413030aad2ae701750e4758fba3914450a5cd2caf0205c87b85499fcd3048e"
    sha256 cellar: :any,                 x86_64_linux:  "a2bc95555e8715dbba1f3f33ab1e80352987bad42bf62a33f40cbc0327b82e10"
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