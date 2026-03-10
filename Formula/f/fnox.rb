class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "2cec2af3ce08c954544a2ab8f28788c8b1a80c0579f599691e39125f20cd636c"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbbfb5600814a33047e891e3351f560e0858a9509f158f073be8c51612d6ea88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2d0dc9c0b4b277de14bba4181869b6eac6915405a96d7b4da531f29a857feb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13dbd967afc512fb12f56233bcb2fa39e43bc559fde510000c21c738026a8df2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9562a04f90d062372a6ef119c49d53d49711d4f80f6099410147ac65a3b4e58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21c7d702de1fd46ce2a32841a3cde2cf49e7d3c4d56711e70897eff32b6cbc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffdbe7dde64c337b2853c5f8c18958f75f2b4631384281a036d7d9cd2e43e253"
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