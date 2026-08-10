class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "6d8cb68ad960e4dd864211e13d2da8346336bca23ae00a4f4f67fedaf146f4ee"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3de28cd7fbdceb6bf7fb86ce0646e2aaadf314daa8f7725aa7dd163a10954e98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c89f2abbeea1bf45d21f65f1b397aad0a0c30872166cad2bef84f6dcead0c86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3d10e23a0f4dca90ff24d4e74f7e954674edc204204efb5e4d21e5590cd3d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "90c26341f054d8b52cc7e5d267060828ec80a2e2d411b140ad940842ef011113"
    sha256 cellar: :any,                 arm64_linux:   "6d60bf6912204492a5b4348e2099e758f0d84edca38de799de43e48bb3b192a4"
    sha256 cellar: :any,                 x86_64_linux:  "b475a6182ee7ea084d29e3e49480c4ff035277f14e36e090a6829efce453eff4"
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