class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https:github.comBoshencargo-shear"
  url "https:github.comBoshencargo-sheararchiverefstagsv1.2.7.tar.gz"
  sha256 "2abab1cba4ce8dfec5b25a2bf04d4767ab3e70a8445e0b20cf8542c400c7d566"
  license "MIT"
  head "https:github.comBoshencargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d75f921272eacd38d46c1699ab884958beb17cfd347c78e9cc0d9549c2ba0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d6c282c6318f06660cd1de6182d8d3c8467777f56264bc8d97eacac986b7dd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a75d0b029b5406f364ebe59a34a7ab64f635c6090ef9db0134ad118f20708a67"
    sha256 cellar: :any_skip_relocation, sonoma:        "04608c7f42bd44ce0fa54da28fc4793d9fd1593ca806a7f4f02d56b740cfc988"
    sha256 cellar: :any_skip_relocation, ventura:       "3e0e298d5d55ca409c0b36838436e18baf6b9144823845b3a3fd71a2b3e69624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53992fa491f6a7a582beeb66944db7057e7a338c59857b55e0f7e895fb52d44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390dc990b4f6fdc4c4989cfb10093c8054902f47fc9521b7b9da127ac8ac1217"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate"lib.rs").write "use libc;"

      output = shell_output("cargo shear", 1)
      # bear is unused
      assert_match <<~OUTPUT, output
        demo-crate -- Cargo.toml:
          bear
      OUTPUT
    end
  end
end