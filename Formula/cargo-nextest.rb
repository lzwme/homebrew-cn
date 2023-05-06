class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghproxy.com/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.52.tar.gz"
  sha256 "bf1726e5a57d734093abca10e26f1c9201ff606f8f35b294f644efa42a07c74b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd89ebdc86737fa61c2d323b04719f3530ff8b37fc45e4d75c043f59e0f70b5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ae43252828223141dc6ab8b8ac1b70115c8e6a783df981b544443cb51585b92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83e7f281cabb0a07374e0ce83e97aff30051548ec307070ee931b07b1e72b7f0"
    sha256 cellar: :any_skip_relocation, ventura:        "9e0da6b6769ca22a1566940f0f7282bd3fc0c7df0b1c304abfa8d46c0be498e6"
    sha256 cellar: :any_skip_relocation, monterey:       "8d3851924d7a439d4937910d9f4fedc220aef932411dde833f413341aa160f87"
    sha256 cellar: :any_skip_relocation, big_sur:        "11b9c92f21d6b8274cf2fc429454918397afd149e7f695e7006ef36e9bc2a034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31bda36e096999edfaf3c0b25bb7aba407beadad626b076542af3e1dac7f1d8f"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
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
      assert_match "Starting 1 tests across 1 binaries", output
    end
  end
end