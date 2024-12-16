class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.6.0.tar.gz"
  sha256 "e8b49e95f40c050ef684b94fadc3ff55e1d4a694e215ea68ea82ea5e676c1e9c"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de10531364c0dd80033571ab33baf5a36e3f6b535fa5eac5fa1dafaf0e1a6aaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f26edfd89146b70abbc02da5f1f179fb2caeab040db5b80f3b30140194ffea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb51e82ef31cea6fb9593a63f12cfc67d9187021ee90be0ef4602d3d4a352f3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a337e506c7b1502c7ed43f5177be60fca05611ff19839aa84c119a4f48924ecc"
    sha256 cellar: :any_skip_relocation, ventura:       "d5e94a340753c5bafae3e16bf70fbcb8eb61bf8cfcee2074f96bf17cc75296d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9529069169da86d41c231285cc014578d110dd7196cf6191b2b7fd8f4e69242e"
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
        license = "MIT"
      TOML

      system bin"bacon", "--init"
      assert_match "[jobs.check]", (crate"bacon.toml").read
    end

    output = shell_output("#{bin}bacon --version")
    assert_match version.to_s, output
  end
end