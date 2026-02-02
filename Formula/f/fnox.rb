class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "0e9960825c02b39e1a021f5dc5a3dd9cfab48b6e24a2351ea09ff5a129059666"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f96e48260445b86314651a97993599f77e43c58f3a3b6c7567117df611bb8162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b7900c8ade7ef45038134c4d1af3a2c0b57ef46d391576db99ba6b302e00a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5876e4b7e39046fa6c5804a3cefa2abf9ea2b2b23689f4740c4104590d554b62"
    sha256 cellar: :any_skip_relocation, sonoma:        "f498af512531f4380b9bd89e50f993994273984df394df3441588b256e589d78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a2e29c06e84a5e05fa75bad99aae0995c3b2f71e83ea68205370014ff851ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd739189e9a354ccc2198d503a681f81516d2f25132cf19719290318b4bb0dc7"
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