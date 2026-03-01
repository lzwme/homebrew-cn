class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "cb4bcb7d4349dfceab2abcf43b36cf99f1e09a0a8b8c6f77e8ff000d3483c053"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb50017d09cce6c7749528867cbecbf3e23bf6339fbc9ae5274e8c2186f4403e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260b00fadbd1b5d52fdcfb6c8ce4ad8cff6790a07735f2a93e645b9d057f69b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4135d9df87558c5c831e37092a7bf04b3414d4622963bd2b26f157745298cd1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ed955d9db64c6f673578eb640808f24c264f9d3ce7d7d9bad65888a56548521"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f3bbd630ea514c3c5886494737c6570842b9edb2ad859ab1469a520ca14045c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446d513cb52de37505af7dee56f942022d657496ba58d8eacfc26ed64afa9904"
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