class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "5496ffaebedb9de07b603ce1bbf871f2aee30e5c40e0990b2e5cfc29f1b6025c"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c71fd457e82ee950b737d66bdb67dfc926d33023914b5dd0da1602d221681c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f27dc00e902f0f35292619a809fee6ffac9b524baa5c6a53db87a809bb3cd0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c975084a1a7a3e3fc2c5e7a4aad8c526075a6224a550a9b009b9382d5a9559c"
    sha256 cellar: :any_skip_relocation, sonoma:        "293606852e95023669240c4d63b4737ac254d984190555ec93bc214c8e52c7ea"
    sha256 cellar: :any,                 arm64_linux:   "a357543b4c9effcb959f373b2a33d35e980ff6876b1b33c6a40d682ca2a10f35"
    sha256 cellar: :any,                 x86_64_linux:  "435df1ac3077f1ac2d686a24d17f681fc5861013227b588052f05ae129d3e277"
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