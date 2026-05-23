class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://ghfast.top/https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.19.7.tar.gz"
  sha256 "847a5377d6a689520d9a0459d7aea475c17248ced9cbbf6f823ea9be803ba871"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe4f0cff33f9aeb46a5c6c2a58cd5ecb77940bafd693d780092ade580eb00880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83766dd44d8564706b78b5d9249fece78c871e836014ccbb89e84e08c013bd7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e7b6bfe6eb18f6f96bf80f787c95503fda131c1d0a0b67dcf642442efd5c991"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e2e94cd20c6e61c3b8514a188266df5a49515413edf5d39109def2c301a2e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6489e9aa02b692ad2bb669161877439ef01fbc19daff3206192b94292dd65a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5382cc880bdc2704197cea963e0061bdfbd1834c0c6235c4d34116ffa1dabe"
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