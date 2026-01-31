class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "5ee8477d6b094b32ff835294959859efd3b706a45b4210168352017f905ddbd3"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38ccf5f378fc09533ca130eaf4631859b3c58ca89e75abfc1ddbf7f27f282595"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62fc76449bd40626eaee3609ec9b350ad917ba180b3d4564642424baab7f45a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "225c7456aaeae87c4cba4ceda86b5cf497a7ec99214041bf7a3429c1ae6ba482"
    sha256 cellar: :any_skip_relocation, sonoma:        "477dfb23b40a5f6cbf1e637b2994bc8c5be3a26965d4310304cd5b03ff99b825"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "254af20c88720bedf1cb3b2f7fd2595f97fe8a421148df32e287af0df45ec421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63adad1c46f7401e447a3467854ea6d62716ca0ef47bce814aaaf7bce52e79b5"
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