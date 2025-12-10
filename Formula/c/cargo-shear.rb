class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "f8ef7bb5a02389ce72c1412d03a7e411d56d26bfdbd8bd343a670b630e1395b9"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "662d4f31c42e30affe599e5d4859e4518d0e375e6e2a15a589687dbc236bddf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a0b150f722f8bca010dea6163f1d946bd3bc7a35787b8324c9b47d233e2fc58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e6a7592e11193fa8bba61ee0e1ef903f39b13bf7b8549bf3fd353e8cc327f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce02273f057702357b144f9744c821120e35fd39540cc2b75f2cf63c4fc357df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "571a81a5af64aa08e5c06e105a445d933aecd91988836d390e3e5c746eb80d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b758f32a26733f499ff3f655882c5c35f09e857047a83a0527e44db4df0acf76"
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