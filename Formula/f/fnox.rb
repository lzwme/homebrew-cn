class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/fnox/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "c688da328088f9811c947e1cb1b85b261efc39c384af10f33cb12a1231f297e4"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6bcc516485d5a947e31dd6fbb9b382c75bc5dbc9d0c2b4bc6d9232a0cb1353d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55ada5b7db48854d492d8ec70ea1b52bb1aaf8f2e72146b49e8178d4bcb86de7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6174a4bcb7ae5dc091a9a8b259da0a52acb2dc070e63c09ed7d2cf8c5a11519f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9486c176f33962daba28cb716e8feaab55599a3cdbf7ddcc28811f35af999b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe4bd15f36a3f506b56ba43205a7daebfc01b8ea1dc908db566fab20d4dae63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "817758ddc785c9903630060fed6c1098b0653f08b0f20a7ae5a3927809b71d57"
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