class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "21669929b2517e7b5425263c75c5f055220126cac1720b40549c316c92db77a9"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d8a0e7e713caa73daf1e2d58db2b0982806076540fd66d819aacb65d48fd157c"
    sha256 cellar: :any, arm64_tahoe:       "78f07bb60a2f77d7edb22f62b0c048cb14c1fc07c8dca4bca675ae597dcaec3d"
    sha256 cellar: :any, arm64_sequoia:     "6a3c702545d02f9cb72dd7b5a02b1e6629c48ec5062f24be87a9c36690114a31"
    sha256 cellar: :any, arm64_linux:       "e553915d7b53ae5e174413665bd45b4041d86a9bdf83841882d9692818ed9a96"
    sha256 cellar: :any, x86_64_linux:      "ccae0702190e1a1b6310504e0394e456d45da5904445cafc156c36716adb170e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "openssl@3"
  depends_on "usage"

  on_linux do
    depends_on "systemd" # libudev
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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