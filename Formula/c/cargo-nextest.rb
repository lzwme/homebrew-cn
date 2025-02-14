class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.90.tar.gz"
  sha256 "ad599ee8eeee53c13818b0807556cb784a131eb0a2f89e58ea48d250a6df5a81"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1b87f882d6386985d93c7f9ecaa2040cca603f24e6ad1ca73a5ad8587eb522b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f5bf8f770b00367648d11431b213d43dae229a47e99769058ba4aa9cd2cf22d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7327c1c82594780aed9fe9b4d6ce4786841261e1257cf8f14939169d649d584b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ccb5c020f00c154d38fffd86aec8a7f393c0a209ea7522dd9d385ae314344f7"
    sha256 cellar: :any_skip_relocation, ventura:       "2cb1a59ffdf752f124098d93d74ddc8d5d02f21266c113d167b0e58458dd337b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72747d730afb549e5992120ba7a632613788a8e7aaf48ae70573be7ff0eba19d"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
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

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end