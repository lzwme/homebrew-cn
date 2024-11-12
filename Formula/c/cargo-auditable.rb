class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https:github.comrust-secure-codecargo-auditable"
  url "https:github.comrust-secure-codecargo-auditablearchiverefstagsv0.6.5.tar.gz"
  sha256 "5e7dad2d00cba7f09f92f457999d15b7fb786a5ddd1adf87ddbc634878ab5589"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comrust-secure-codecargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60928c67b16d6a617c778f08b4bbb7b8d922dea2a7ff1ff4f54e6b6cc66650cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89aeaf91fe1fcff9a0b3ac510baeb363e34bafe0bf4b24c80b439ea5ec248a75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ad6bd14a6db7840b0722309601309a3e7253ce3e517ae20c356ce84420a8ea6"
    sha256 cellar: :any_skip_relocation, sonoma:        "696c006aa2fda55aa8a433ad76798622701e2f21a846f9449a11868366d9a0ac"
    sha256 cellar: :any_skip_relocation, ventura:       "5b183d8e9cdb1e2f973b6add241d06b672d06c88bac9ee27cf62309000700438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730bd26957690a15576702db17fa620dd1bf35c2ff73bdd6114da4236c473b66"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-auditable")
    man1.install "cargo-auditablecargo-auditable.1"
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write <<~RUST
        fn main() {
          println!("Hello BrewTestBot!");
        }
      RUST
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      system "cargo", "auditable", "build", "--release"
      assert_predicate crate"targetreleasedemo-crate", :exist?
      output = shell_output(".targetreleasedemo-crate")
      assert_match "Hello BrewTestBot!", output
    end
  end
end