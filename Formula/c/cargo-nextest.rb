class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.69.tar.gz"
  sha256 "1c12f0bf937984b12208f073a9e6f28555605f2d0fce8b3bcbdb768fe8609559"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36ed928f506ffb43e404cca10e1055d1477a71c90a2ef73a256a6e66bbc5e428"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b25b4a4f82841e3ce8b3c5aa02eaa5da98b2f9601f488e6197ce3c79f33a50e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c572b11539e3be4481d242a1ecab0dc66440d907f2cc7385771b23067a56a034"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a67bd412a3249171cce323a0728af9c7148545d65e2bbc1c2000db2e67051d4"
    sha256 cellar: :any_skip_relocation, ventura:        "a0ceb5ff2f9e618a0b22a51da8faf82ec1f0a6a8aefa5f664f4c0046c8a912c5"
    sha256 cellar: :any_skip_relocation, monterey:       "bc922a6a3bb0070ad4a6d4170e2704bce2d8b300ad6d38649fae32e0e4d22310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0105bc24609b16848e3ba848e298c965bd0a7ff071f0eb84ccc3d02cdbb36d3"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end