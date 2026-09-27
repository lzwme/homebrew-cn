class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://ghfast.top/https://github.com/Canop/bacon/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "d86249d01175f83ce30c7d52d36ed3422855c7eef00907161e673d490955702d"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca223043e4a28db5fa369a5ffc8c14368112f49e0940c242f3880eb6d2a67a54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b27d3533ce8c8ac7abc1737c3d2d7f8fbe1be1515e952b32c5b42ac247d9bae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9084b6e9ad5c57572f84e0175f2f20e3ba1ebb14660bc89884478a844b7a4959"
    sha256 cellar: :any,                 arm64_linux:       "b397d1c665129398b4742a7a8ac6167bb7315ee5bc12b72a94db0b0b83a67b1a"
    sha256 cellar: :any,                 x86_64_linux:      "70153aee87958cd6b3b49c161c78fe1c6c179729b5d07cec6ebd9de9c14211e0"
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
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
        license = "MIT"
      TOML

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end