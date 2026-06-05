class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "f8245a9eabd0ea457334d7638f902ce0e40f93dc91dd1255bf43d52b7e3c675f"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a570e0c2c03f87eb6e1e5f8cbf3153e01b373b4a0d08a977d0d8696cd274337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f7485936529330f68326f939bde48163ef57191b67240cc8fcc54e5e2f4ea78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a3903ca3ff13623573194cecbf805b3ca7702704fdfa80615020f789f9c7f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ceaba2bb3c3ea0357b056cf7488fd6927e8152d4bdbd3288fe66a41f1985a02"
    sha256 cellar: :any,                 arm64_linux:   "07bf12773f41093da8dc7b64a3be2fdb41f207f361b666daeaca4ed6b5ca2a8e"
    sha256 cellar: :any,                 x86_64_linux:  "8e9e454dd5ca410816a35ab482040c56be43fce99db3913221867ea0f1aecea1"
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