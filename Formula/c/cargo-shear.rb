class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "3256f8f9cf1f63d99064aee3d86d9d8ec220a44c1a659e7b7faed20e9e08bc0c"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e17a2ccd40cde6307142bee07c00d677a8b22ecc642dd612fe6b08049ea37930"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0178cdf37fac596870672abb7547083507e3ccf1be3306a357261adc20b611ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc4686e3d8baa293f199840ace6d3a550b638f272572dca742e535e1022fda7a"
    sha256 cellar: :any,                 arm64_linux:       "d9dcf873db2eb7bc9a235f36e2d103bbf50f7453995c72182af12b2577c8b343"
    sha256 cellar: :any,                 x86_64_linux:      "96c5738a8ec0a65fbe7f3c9a1fdca5e1eec9b2eafa63e800923ddd0d9768118a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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