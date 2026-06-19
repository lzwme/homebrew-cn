class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "17fbd495ad626ecd2bc7eb85a632d5e6875a49a6effa7a7aa6fafb9359ae7640"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60c36a55120e4b1ee70395c4eee10c6cdccd3131a3fed2edd6b551a807e6a560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "995efb448a07e8d8afb1292a83512c4d344174296224644ac3da1c8858d3a955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "261496d20a9d4d5e60758734339b6bcbdce881ead424e4db1ec572a78a83121f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bd0f5761a6cc8983d7fee8c6c812c68f6ea08b778b3a5bff290fe3eca075853"
    sha256 cellar: :any,                 arm64_linux:   "225ec48a32220082201008e8c696cb8110998f150756607b3926f9e8b36e41bc"
    sha256 cellar: :any,                 x86_64_linux:  "f0d21dfb6dd9e2b7cefbcf697bf8d27ac3c14c6d28d47b20c0dcaccf8826b90e"
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