class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "79475b840e0faa23dd395bc30baf2a2b0f4694ecfce4d1f18816f513c4298be7"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4bcb5ad292ab231c57fdda8a7186ab4f1daf5dc3cbdb25fc8b15d4a75d2ce40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "904adc792f6383fee53632b77e11785b94942e4633aad2edee3f08eb1e179e3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "228d7b8a3591fa327e7e8ada6eef603e769a0d1d2442f492595ba7eee063a41b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f78cfdcbe43a1ee4dc2fc25f9e468c765abbd6fc96eb4692ff2be07999979bef"
    sha256 cellar: :any_skip_relocation, ventura:       "766bf5f4ab73761b10d44a05a7af6d8af8dbfcc4e05dbd50c00474738b724fc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e16b86eb00299524824cba03131413f14b7d0d7fc3ef548d1ca076966568982e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0426100581d861c9b538e8cd56f7ea194efe3b16ec6f870df934186cc40e295"
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
          bear
      OUTPUT
    end
  end
end