class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "0d4ed089ac2f30437b9a7adf3a7b2cc734c6a668b32cbfac30e841647bd526dd"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eb7e8051f9c905ac6e119dd36e0a8d0fa8d06bd29c59645fb673443a0af6725"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54472cd52a96c14b823f9bec14ba1d4455c56861be6dd95ee200a561a4d92dd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2826716da780a71a07d56afd84d7b533c75ee8e3bc43aa4aaba3f4a3451c38d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0ebd4b45f694e5f6353e5930982fd93b427f85b7a744fec251af475dbc0a0ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e64dab00fa542b07d58ab59be927d9a6a945dabce454cfa03e01585bfe3d32b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3ea2ea60dd0db208e5093d5c3426708472df7eb290c392e1ad485524f47c37"
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