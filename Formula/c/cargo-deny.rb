class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.17.0.tar.gz"
  sha256 "c3f34d734a726827c223529486d3e87986a155deb78f52fc864cbd6837e02d1f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfb0b431f1ae094e1b51c1e5a3a4b7527fa1effcd7cddbb106d52d1a9908072f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521795821f719b7fa209452d2758640cbe5de791ab02c9a3e20a61c924714b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7483f2b2dd7c3d146a6c7d406ed8171a5764e99273e9d6748e48a4cef90a0384"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbc2b3f6adf882d75a4083ed7ac5637048644e7675ac0560bf3fa7df09c6534e"
    sha256 cellar: :any_skip_relocation, ventura:       "e71091c856c81a1bc73f337cee2c57714ed6baf530d6153a7c832d62fd653387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46fc9a8a48a7d080b1fc437e924af9a29cbeb07ce72a8e4ac422b86a9003b557"
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