class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "388f8e0bffe2f5588e5eb39b2506f82291d202722329dc09a50d8dca48e9357c"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f6c5e894f977348138c58f79ac3e5a1d349a29ad319cdacefaded9c621ff064"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d296f7c6c01fbdae03baf949e1553e6c6eea21135f44128463456ebe8b599c71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e30c577d6ca37bc6d069f8172f9ef15a2d985ae962d151801fc77b9c20f46f73"
    sha256 cellar: :any_skip_relocation, sonoma:        "6568c6bd1a8e1872716c9f347d806ff7a85f2ce90623d92df4262573e0f794d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acc17381b7880ee888ad0ad73aa390c6d2cc3599ff61c190140392f6a6de04b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06bec36ded61324903f1bfeb924c510b1519140f3b0603822834fedb787ccc83"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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