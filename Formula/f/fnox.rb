class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "78ace2c8e8883ab904ea25b0b5f9efcda03f998c3dbdac6b099b21fc7628582d"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c17d2c121b58fbcd057be6d073ea79ea896f8dc9a8b02991fd8ee551c4f50a70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b6eaaf3890c76171df2be1b62223b678b77eaeb328b5e1ce7f64872beb31fa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4767f2fb39c6f677f2271edc76218d7128862215a1993d0f5392cbcfb66c0c5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "60a6ba4ab1e3d705015899ba25aa39d62e2961193a1b2ed1aa012248884b76e4"
    sha256 cellar: :any,                 arm64_linux:   "90a750c122a4a341b4959204b341fb69b84cac606bda6ae1283ef1f11e281166"
    sha256 cellar: :any,                 x86_64_linux:  "41dfb12bcd731b525b9adce98ea34f84313720f43caffbb71a122c6816c59ae4"
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