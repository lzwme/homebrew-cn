class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "c12c2b2177ead2d1ee25762eff18a876570fe3d9becf4e19ffdb185a8b1eb3c2"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0692880d668889056b6af748fa830742d185178ee3e59a1572d69a3740dccc7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cbb9a4c9b37abbcd3f801524930ea7d3164241e268b2f3c69f396120293315a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba19f46f4433b7d528e39d8e125a0bc25cd05bea0a9ec46c76c87c54f73865fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "df32ddee65af17c39c1f3c447684860da7fd65c92a0f6ac54563066d3c365d4a"
    sha256 cellar: :any,                 arm64_linux:   "e8a32775fd3fc6c4a2a2d1b7dbcf5e0059a13b874e1b55e4bbc4d85fef50f6e0"
    sha256 cellar: :any,                 x86_64_linux:  "b65873b92ac23f70dcd8a497ade1cbb62890b10f92eb1b921fbfcb9125ab3c5f"
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