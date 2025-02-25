class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.18.0.tar.gz"
  sha256 "77333c748acb6329bd696953fc3bacaeb489fbc6a321ee334cd0c1727208d8f4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd698d38d89b92d92ebe63e3d209c22107beb0f5f3afd11450406fca6477bc27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33451106176174313f289de2fda043b94ad7f6f51ff5a1ee0259a62794258df8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53c5c8dffcec650b9aa64dc33edfdceaa9ffcae2ceb5597d3f5660daba7b4cb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "93eccca70c12675961cb89607f7fde456bccb6770feba93258f515873873191f"
    sha256 cellar: :any_skip_relocation, ventura:       "eb3222ce943e6366b8c4b88f8a4ae401ccbf8a31fae557bd4f2a3b409544e73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff58d281db71843eb43f99383e22dfb72300cacec3540de8f0afe1269ba45f5e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
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
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end