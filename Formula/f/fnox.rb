class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "2e183e5e90ab6ebb54d22c3fc990fd36b9e43c0311fecd28373ea4170776188f"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f6d255e6ec935f2947713a8d862613d15856a89091ae4660310f99dd7ff59ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56791f9e370dd288b08b11b2fdcb465f371cd40873b87e1c693be070d81b7fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cd595afebe4b74280dbd9f9f2a5e6498072cacbf2a75667a166f6d71340a6f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e659cce4d216b093bde5d19298d76989accb384d0650e5d3fa282709332d75e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "278f52800d734b95e21159b564d1cc4f8bba02bf3f7fca4372f14606fb6418b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34830bfdccb105345b20b0ba62b05fa9e89e6f969e0f682ee8228ffa2da74f6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "usage"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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