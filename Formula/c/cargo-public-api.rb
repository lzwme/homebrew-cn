class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https:github.comcargo-public-apicargo-public-api"
  url "https:github.comcargo-public-apicargo-public-apiarchiverefstagsv0.44.1.tar.gz"
  sha256 "99bc7ac5797a30f4a3b495bc41b54443da3d0a451e043e27b631385931d79c6f"
  license "MIT"
  head "https:github.comcargo-public-apicargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20d1e3413a73fd88493338af408c2f1e5c00ea41b35b8a6cb167858f2b5f5ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a60dda5777fed1013c797d1021badd40f6ee031ac13ef035c0594b0843e0b784"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dee16441769c18e892cc3dfd5a10990c4f381a532afc0d304f878ccc6c4d756d"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ad0a4c21d4f4a4d9dacdaa6b03660dd38f66c782994bef298c43781e97f69f"
    sha256 cellar: :any_skip_relocation, ventura:       "c0b8510a2d0a4c10449e94fb7f73dc57885cd6738c9fd821353ef3410c8b0ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "411b5607d7318e683c55279e7dd6f1b3dc363bd66f34f2b09bd16d0947de59d7"
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