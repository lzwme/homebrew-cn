class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "4b92eecdc3cd15e4033029559ef87c27a78451be178663377b639d08c23757f0"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b313a4bce51d629496bd6604d824ea38aa708db010d3a96fd5c2fc60dc72f26c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db7a7917a7c2a17262e36db96676b0294958fe6fbd45eefa2e0e01aafe921a61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68472254d0ab64f97862ec6166c3291415e5a0503b741c6aaf6942f0a1174d19"
    sha256 cellar: :any,                 arm64_linux:       "fbdec3d08312d8aba100aaea2f5042ff9731d8393bbda7af6506f2ff8f79ad37"
    sha256 cellar: :any,                 x86_64_linux:      "caed2a5c30617e61a273756bb3ea6ab1c043f2563cbcd10f8397c301f2cdb180"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "usage"

  on_linux do
    depends_on "openssl@3"
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