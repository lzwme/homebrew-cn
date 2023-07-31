class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghproxy.com/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.55.tar.gz"
  sha256 "ab6b26e70542b1a3e36530c60bd726040f6690c53e4ec32f04c93d7ffb87094e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "843ac54df46b04f2f18493e310c98b80d78b93d7dcbf143329d1cba1d68c327b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dc48439e74762b9c8124280707fa53a8e19d2096ddb0b257282279bccfb65d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edc1f8d6533347d18be6042ddf38ba425067ef10ecceab37ace610511068ed9f"
    sha256 cellar: :any_skip_relocation, ventura:        "2cc1bedb07a9038efe84817d2fa3536493abb0ca6130268866957e2ff8a25407"
    sha256 cellar: :any_skip_relocation, monterey:       "e452c91783d75b3aa31e7b76a6f8bd660673ca9c62a254b2089da2bc9751e929"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cce75af50d5a6a67e3a53893d991756531ed308062d072f343711a956c54f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03229daf2fef42ec4f5c974cbddab281cf8d84ff4abfe4ccc03fbb16353517ac"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end