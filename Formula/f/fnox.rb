class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "9c6f0deaf8eb35da72f264b3cc3d1a824ad7ca833b53c47829c5da04fc9299d1"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33e9438f3624ef896f45424148b2c7d40201d314ce704cbcdc1057c90d731f50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7b6f0942aa17039544edbe1dd692b052d895960437b217a02b245af9ba514ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9fa1e17cd2a2239ca4d6262366fb6ccbfe9c12688db8ab0b0d069b4f6c28193"
    sha256 cellar: :any_skip_relocation, sonoma:        "aced20ea756cfb574d0e2fca9258d630550f35f7bd02e3e35d266846e19751eb"
    sha256 cellar: :any,                 arm64_linux:   "1bed476acd1845c6658dd154fed2ae4fdc14e1a6f87876783e3794c95cf46c4f"
    sha256 cellar: :any,                 x86_64_linux:  "2b3fabd6e311c168c59790a7876e4f403ba4eb395c5522df9ea095adac5c0f5d"
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