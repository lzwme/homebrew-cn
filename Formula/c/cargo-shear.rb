class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "1488c81453f2d5af77a25fac86933a3a780237592a8286747bd1c89018ac515d"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3b4abb23b628f3c8f522ed920a4bdfccfe5982218de113d2d0fb2628cb94a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c17f071cf22e5870ef47c86c7aaa47ace2a991ddbe000c2f519c4621991c61d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77618af1040eac03139223a7a50c76273128ed8527e0e0f5ac96aa8baeddf0f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "692b664cca86ae96759c6b7325495f54e9b8f69cbce49ff31c6554da7b656686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ce7e224532cf5c240246f9fd9cc2a9c1129d402723739d90c32edef1c2db842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cbd441bfb072eebf7f750c3e989ffe990ee2b21655d8d362628312404a47ad0"
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