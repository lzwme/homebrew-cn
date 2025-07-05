class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "272d9cd73467186066c70f17132ab3cb15d7dace00404d849dde4ae3bf3ced2b"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf7680321c816ac8f154300c1a34be9d27b86e5a1a1911369b632ad93762b228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de1e1594d1406c226ca884801c0898eac60f9a61dd679cdb9c00db5249a9c7c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4fdb371f918d671604321e68a6cc9ae7d8cfbe5d28d4659f04429954a3b82d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "37b85f9882030d2afba770993ccb72b4489267fe7a7638ad5078211525b3f960"
    sha256 cellar: :any_skip_relocation, ventura:       "c310094793d4cea2bb95c2239cce639a15db79bed4c8ebc18cdc399ef774fa0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8905d9fe9db87351f9621ff525100c4f2be9c5e74389500ca620b848d7ea0e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "359988d549ecd834872ed78232e966e29e303069191e684f1069a16953d23f1f"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo shear", 1)
      # bear is unused
      assert_match <<~OUTPUT, output
        demo-crate -- Cargo.toml:
          bear
      OUTPUT
    end
  end
end