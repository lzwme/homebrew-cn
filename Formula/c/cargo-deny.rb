class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://ghfast.top/https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.18.7.tar.gz"
  sha256 "a0edac47912942ae4a10e099dc38406229440819626e9947512e8faed973fd58"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecb6a68225685b16a018ad5970f5340e8e6028aa278a338de0d9a243650449cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cb2596f521d4af4a6ae4fa2ed7bfa9bc0b94a4b1a5b5dfefc4469ee5ec36e27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "349febcbe959fe6224abe7a0f36ef836ba8dbe69826677c6a206c475c558e28e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d36961c3c3cc417d4817d4ccb5c977d591342a48490d804577eca05e22db31f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8112043d1deae6d7658a794334e22caffafeace62037959db46c9baecb7c5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0c86408f5964ba5f913e438f37d3aa4c33b6e41e3871ab2f9403a315bf45b87"
  end

  depends_on "pkgconf" => :build
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
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end