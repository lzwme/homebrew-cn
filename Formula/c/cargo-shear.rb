class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "581b7f5166b59c5e9bc9842adf0a582627f3c5fcc48c8ed8df44f0b8f4443b31"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "925158b01be873f22e66e3d80e4400a9845ac266c46043d572a3ad748d45557b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6e38a9a0bad3968096f8f3e43ee33ff42c0ea9432f12bc9478f209590440c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "653ffe3e55d5d95ed690878a1b3e85fc9a9597f45c109065679842a72812cea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf8950d11a05f4656ac93efde7e2e8efdcb79d7adc3d58e7c306504432c80261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1198f1b27f3a98cb872e371639a02c5173402b194090ffdb6823a4a304f0e249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe82a40c8ee95d721ceab9948724dc45185b9c720a8600fe2aee4d8c5a64d05"
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
          unused dependencies:
            bear
      OUTPUT
    end
  end
end