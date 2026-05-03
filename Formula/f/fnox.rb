class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "6fb698fc0a98bd9ebd957c072c6e449ff52009f7a553123b038e38f89e601dd0"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c006053ab78edda8d8b5835fda7777c84227c360628d9ec1ce244a2742f1cbfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2134b6b8668932a35b4ced8c0c1624e61822332f428a8382831eb00bcca5ce7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfc330aadf05404cb4216ec87ac1540b0572de2d4797e360982b79735cfd624b"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b08f3d7d7382b4e044997660c00b0bbcee47e1d00ca2975746369f446a2ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a95c622c7be7ca7cec481cbac32dd14a3960662e05fa2ef7ef3d23b22c9107ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0dc7a343ff85037c28fd3986ec4ab0c98df830b905b8bfbd9e0cb86539ab130"
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