class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "394b2478118c3c55947059105207de03f19b3b3a81d62dae79f93c659281a2d4"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4c32711de26e6534427ec43d9b0d3e0c7134d1ca25d0a96927b684e54088c64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db9d0a52a9be55b83371b0c7c5b85cc486c8aa5d808f6691cb37b7a6abbbc65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "735b9143a281fe09cf0d6e1e9b70ecea1c1dc693393765463e2cb82f1232e502"
    sha256 cellar: :any_skip_relocation, sonoma:        "98c9af4d1f227ae867269bf9bb54e1062c22c2899f35b321b37e96bb3c53380f"
    sha256 cellar: :any,                 arm64_linux:   "3b2eb3feacfba10368602acbf43cadeb89f7ad76a45d60f2b70c22bd85a219ed"
    sha256 cellar: :any,                 x86_64_linux:  "e73fd897f9f604422a7d5208dbb007031a10e05ab39a3ce2125eeb141d544b9f"
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