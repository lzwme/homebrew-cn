class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c405f88d61ddfca0fbcc0a9a2e7d0c41cb9d45ebfd920da910810c4b64c89d19"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0219ff8c09f4e167e67e0d17d3d3444dccf365234359d952e27707ccc196cbe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b2c31f672edaaa066ba133319e9b6d2285cf7ff4468eb88d6bded84999458c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d347a15f3e16dfbe7c4091e1917d967d4e45644d64ada33570788ec17226a2a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2313df565c25e90fcf1d41bb275bcb2c7087ef2d2e9bd7a27356ad106d6ac84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3005b2e423e8ddd35f80c71a307399d82e75e291b15915b7ee746a2853144220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e6a9a10be8cc74a6d21f60c78b272982e0466a52c50cc2724b69cdf8fb09059"
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