class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "cada6703c61325b6a3da9e1bfd9010391c65da1479af57d1594bf714272e8102"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54d8079712f32fb3487be79168d947c63a35ce083720d6183e8329d1a12e7067"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb6c1258883b3d1275bbd85df0524255c6f8eee1af3a2985d9aa38f557e0872f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c72c0da5ebad5657524689c7b4ea41de876766de9885dc489612ce5eed92bdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd31159569f71669dacb5beac79363fdd3254bbdb53651aafd435a995102ddac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c30a7704d1b1d42f32964fba4e854cca79e932ac4ec8b103e23b6d5f82e4dece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a01992beaa641a97a5804a84cec40680338df99d89a5f3da764a421199db87f"
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