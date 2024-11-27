class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.85.tar.gz"
  sha256 "182a81a334ad52840d1dd6edff72d3b72abbfab7d96147b2db3119724eb867c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35748049f3d65d569d6256878b79cca54946d5eb05db3ecb2de1e31592c0fdd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f910ebe3bfd89ef90acdbb6ae86d26882906df4ef9895c591da48bfd5d6d6222"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0a2910758bf2b04d9eab7ff8fc1942070e24d241317bd62b321f173b3faec69"
    sha256 cellar: :any_skip_relocation, sonoma:        "31c658f68225d63aab72311abe1c7fd3607be7bd4bccc920b9872f6155607b2f"
    sha256 cellar: :any_skip_relocation, ventura:       "c89055fd8e4d773ae640656d81b3a962aeb3144758c66427b8ee61b4bc7fc983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa61a9979f265c24d4729062c246d66f4c53ae8037bb0715bc6dea92390c2793"
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