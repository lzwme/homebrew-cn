class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "999549aaa9748fd76517d10d573bb9b5da75f7a499cd393ceb320ae204b8a0f3"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "755914998e0cc5a6738b62c7cfd8d876d499d73c2ad30e82ce4e52489e9d9adb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "facd612db557c5cbcb0bcff51b1e30cd4d2c5c0be4ddae46a54c0259e89397a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "048757395379cfbc284f89224d0a54fce53328393c9c447dbf10451d21b15a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f335e553e3bd80fa98e45e28fb45d3f12ed07428d757e32412dd47d1adfbf20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca2d6a39964d7ce86065ae9be03577f4bcf8f87b031c9aeac6122bc172adbc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba2c64eb598be001ffa222e5aedac3e9cd27c1202eb058da4862d6816377ec3"
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

      output = shell_output("cargo shear", 1)
      # bear is unused
      assert_match <<~OUTPUT, output
        demo-crate -- Cargo.toml:
          unused dependencies:
            bear
      OUTPUT
    end
  end
end