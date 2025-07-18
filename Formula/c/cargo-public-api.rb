class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://ghfast.top/https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "10af6f8f82cc91d8d55d34686b05dee950c0fd27a41220658fc2e3d357ab429a"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb5110fc2375228991c860853a4eb6c09948c9b9367fc99de9b51df8055d6f70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c562933451a285d9f242b002ee435d83b728efafee7ecddeca0568970381c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d02a10da9918aaf23678369c511b464ebcfefa1c38752e1eccf7e04cf68e48bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b18db5cb8103beb5e04b701529a49543a93043ec790c93b56fca38cdcbb93335"
    sha256 cellar: :any_skip_relocation, ventura:       "a1b5ef5b61ad4c64690a14d309b07b0682e844f2842705c1e256587177cc230e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5851bee6d2cc7e528e6c1e66dbe3dfe3edcf26db4ccb67dcfbf45558892c0c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d016cf4846588f7b4d4bf4ddbebf152cbc8e166684397dbde714e41466ffc656"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-public-api")

    generate_completions_from_executable(bin/"cargo-public-api", "completions")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_package"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/lib.rs").write <<~RUST
      pub fn public_function() -> i32 {
        42
      }
    RUST

    output = shell_output("#{bin}/cargo-public-api diff")
    assert_match "Added items to the public API", output

    assert_match version.to_s, shell_output("#{bin}/cargo-public-api --version")
  end
end