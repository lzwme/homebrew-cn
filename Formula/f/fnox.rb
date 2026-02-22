class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "6fd9da0051120f4b4ce0283436927403a7878d0c57c49a3a31502eedc37db58e"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95bbc29da8d9aadf348cf35622ebd2b228d5d6946e8a51a39300bfd1e1ef1b45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06c18795beba80b3bedab773015f2e7816a854ab3c7ad984a589930ebb2d6df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64be29b2113656e40c4f21be5b42b7db11fdf297512a34d8ea0e76d6871f978d"
    sha256 cellar: :any_skip_relocation, sonoma:        "06c81f53f872dfa18b52f4c7d37b384e3aef8bdfaf2a12b96cb6c77364bd86df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f26d26e57645b495307e03be6fe1ec513dba702e97111a21409b574f72fae93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280d5067c1ff528006ec67779b9f257472da0fe872ca12b1fa3e2120b34bf214"
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