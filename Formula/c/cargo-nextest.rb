class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghproxy.com/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.60.tar.gz"
  sha256 "29e13b8fb63280779501d714a1358191f617efa64db2acb3f32de0391f019a00"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6ce06da2ab177cdaa364b37a7f10ac38504bd6e1771c84aa0c10b149e24efcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a3d95db80e97a8380edf939f21645d3d107d120115e7c464e7af38315ec0def"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5ce98514bea17ab7ac5076e226ec65328a26b226c606b45f3013fa746a5b978"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd9700fad4015b3f13dd7a7a71f7218f47242e3b59cb11e3844f4176bd938939"
    sha256 cellar: :any_skip_relocation, ventura:        "baeb785016b16aaa8507f34a27881dbaea5db7d3b14ba270986dd3cd8fb62967"
    sha256 cellar: :any_skip_relocation, monterey:       "e897d119301bf0cfb6c2dc086fcdb902edc692d5215fbb54967c50b13422d12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ee3316f8f0e1bfe60cd32f0d19636a33ea20ce9a9b888ca85b2e3fc5f3cecad"
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