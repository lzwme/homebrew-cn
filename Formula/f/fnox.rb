class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "b1f5277ff711d180149c3f8278ec848cd60efec3ab02cc50efab6ab4b039fbce"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e76d8e6e575bdd625e91d19cf18e2007f33b688ebec11bf6de6b4f5e8dee8740"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "737ed70ae9b3d6ad5f14c7253d106627f6b58186b2b8886f1bb57c66c7f5b63f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f7252397a64cb5ce2008e94185aa312917395c053da3f10e5f66ccd8efd7fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "7611babf04d2113b8bcd8c985554bffabd27945f828cb1d03e02e050cb4651fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80380f891e5c0707cfbbe47f34a80e27f94b5705ea4cb72aae0810554590d66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c841ffcd43c4d3e1614d4074d5fb9065ec5286617f640daef2582acf8917070"
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