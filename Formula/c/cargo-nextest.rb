class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghproxy.com/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.61.tar.gz"
  sha256 "289c6e664a74b451736e4fc8e2d72d61fbb9eb89d90fd1c6933d50599a747a77"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ce38925dc18a32c55ec1802d6a9d75e3ebfd107c4202e18b7ede7e20207626c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf90dab0a0fccad2a0cf16cecd5da326d58b6f38c9b5f8ef0249a606d188cb89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1fd1f34bd716fd62a96a50a3047b14dd8eef5e2a32e5410ffbb3f46049bc4ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "84cb25433c6afa11e3166016bdf5dfc3b67a1368f765d0ae779f6ccc642b3b38"
    sha256 cellar: :any_skip_relocation, ventura:        "e71f3c88311dad7cfa306c1c4a0c2c33851d0c2d201b6ff1128e81d715f562c6"
    sha256 cellar: :any_skip_relocation, monterey:       "a5fa2b941c27e9b4c00980ef5706830c6cce79d3ee09f54409da25780541d5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceabdd0eeae87ceb092d7c39ad5a5a7ad97aea86549d46a62147ddf9732c0c07"
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
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

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