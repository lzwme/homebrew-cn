class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "7e8c7b0d1f6413d6f77c2489f11b75d153b2e2aaeca5712ca63620348897b0f2"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb6297ebdeb40dcbb8a9ebdbb176f384132e43d5903c1ce278090587b5414b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "342574a13b11d959236384a43d9761923ce074f1b9e1b15b1107592edca4a4d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8229484ac01176c89f430ae191caa3e3ce8335f9e98620f8167fec1f2a48dcc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f6e346298b6371139b352d8e98248a9453d3213ecf3a4206ab51ccdf42ea482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15da31cf5d10d99f419d73b03e49da44387851d55e5b883c57b82e601738e2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46bcb681dc7fcb4ee9c586c23fcc9b9a71218b1da7b7582b70cf4a906c86d2fe"
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

      # bear is unused
      assert_match "unused dependency `bear`", shell_output("cargo shear", 1)
    end
  end
end