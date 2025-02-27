class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https:github.comcargo-public-apicargo-public-api"
  url "https:github.comcargo-public-apicargo-public-apiarchiverefstagsv0.44.2.tar.gz"
  sha256 "9355847d4513a8e5994bd75765c473c025fda0ddecf2babe3c8342091425f259"
  license "MIT"
  head "https:github.comcargo-public-apicargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00280dea57c0cf34b7306d3a1510fe4cb2b7a6004e6c95a7169317ee69e15877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf6c75c5008d0a485da7d43d00434a0e5fa994f3d311e9173975e5232d2790f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "237fcb5ad9726595a5660c6c41e71ddc215f6e38e014e5fd9eeaf45f38add78c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eab8239a667f4dffcb17ad66d42c86a7678791026eeb55e6ec4b4355fcb94f9"
    sha256 cellar: :any_skip_relocation, ventura:       "2547271ed0da8a1a9cb46ed3251c4e58143535f25a141560fa0636ff6e688684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7debe5eac122bfc58b86559de1a8d783389631495513b3523f6837f82bc3a11"
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

    generate_completions_from_executable(bin"cargo-public-api", "completions")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    (testpath"Cargo.toml").write <<~TOML
      [package]
      name = "test_package"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath"srclib.rs").write <<~RUST
      pub fn public_function() -> i32 {
        42
      }
    RUST

    output = shell_output("#{bin}cargo-public-api diff")
    assert_match "Added items to the public API", output

    assert_match version.to_s, shell_output("#{bin}cargo-public-api --version")
  end
end