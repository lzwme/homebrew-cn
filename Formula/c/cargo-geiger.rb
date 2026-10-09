class CargoGeiger < Formula
  desc "Detects usage of unsafe Rust in a Rust crate and its dependencies"
  homepage "https://github.com/geiger-rs/cargo-geiger"
  url "https://ghfast.top/https://github.com/geiger-rs/cargo-geiger/archive/refs/tags/cargo-geiger-0.13.0.tar.gz"
  sha256 "02a3999b58e45527932cc9fa60503b3197f011778dc1954909fb5fe9dd168f72"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/geiger-rs/cargo-geiger.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "8e4e4cc67afbbf5caa621c99841bd7f0b78c4f3be582d4dc404e5dd05a0898ab"
    sha256 cellar: :any, arm64_tahoe:       "7f23522c1c5c01537dc7f6d8c67905f5b09b95b37026abd4c9bdcf0bca85bd0d"
    sha256 cellar: :any, arm64_sequoia:     "5696cddfec7ffea8df91898a6e88039e07736187e8a7f87f237de5e8a333c797"
    sha256 cellar: :any, arm64_linux:       "740563e04496aac705b6ece0d5aa2ed81257b6f4bdc6fb2705fa3b3a43d807c9"
    sha256 cellar: :any, x86_64_linux:      "0c403bb34d236369c9384118843bea1d9c843f957c6b69ae34881981e08f4060"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@4"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport OpenSSL 4 support to the 0.13.0 release source.
  patch do
    file "Patches/cargo-geiger/openssl4-0.13.0.patch"
    type :backport
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "cargo-geiger")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("#{bin}/cargo-geiger --version")

    mkdir "brewtest" do
      (testpath/"brewtest/src/main.rs").write <<~RUST
        fn main() {
            let mut a: u8 = 0;
            let p = &mut a as *mut u8;
            unsafe { *p = 1; }
            println!("{}", a);
        }
      RUST

      (testpath/"brewtest/Cargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2021"
      TOML

      system "cargo", "build", "--offline"
      assert_match "Metric output format: x/y", shell_output("cargo geiger --offline")
    end

    require "utils/linkage"

    [
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-geiger", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end