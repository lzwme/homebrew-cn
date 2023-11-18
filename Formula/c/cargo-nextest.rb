class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghproxy.com/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.63.tar.gz"
  sha256 "c5087a88a397942387f3ced0cdf90f910fbd2bd0804b4afefdfba0aa86697d9e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cf6641b100cf57d0162e5296ace428a6d951dcede8b7e59ee53c10c21c35d35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8262a502bf9bcc12986fc60a5de84c2e9f4335476b5a2a00d4c5e1469e89bc6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e41e783ff17d7230e3c7ff3748842fe9434c50004f691673be9a78301a910b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9781d6cf021e8e02c2123ab612c4ffef750f7a7e94f36dc5693cae077ce169e"
    sha256 cellar: :any_skip_relocation, ventura:        "065ae7e768af04e3132e3bc4523d7b08c888ad7d669c91b3653d81f689ce8dc1"
    sha256 cellar: :any_skip_relocation, monterey:       "69d18cc1fb23eb75db0be647630c47bf3de1402d59710610bced35a3e78c23f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "531c9386613c532c4a5a43dc7f46e6eee0ce903309d99b642e285941470d6ad8"
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