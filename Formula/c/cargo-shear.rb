class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "4dc06e93219b36fced1bb8b8b9da2b948d05cce31a92e777ff81fc6980a43558"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bc459df26cde05a024b6eeeb39412eb4173cf4ff4aab554a44c3313675554ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a428e919a75128539c4e5c1b40433252c3a07c99265fb651cfd2dbe96a8802b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab6bd4ea74699806c942db32ac47a6c0cce698f3332ce65021ce91bcd7ed93d"
    sha256 cellar: :any_skip_relocation, sonoma:        "91cc50658b849519391a7d8984411a86f8760f65d9344a15948bb3d2e69b48a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f755e96bdd837bb399a0a7e457ae15e90ffbfd29255c566d9abe6657aaa35cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6e057dab92ac2861504d650d33e358568e1f250e911517df024bf874d85043"
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