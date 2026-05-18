class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://ghfast.top/https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.136.tar.gz"
  sha256 "26a11327b5ea33ac0790924d42b440ee71177d54b0f7a509461a55ef77a5f466"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2013b675f5381a31a1b525e61073066128fab652ff34b64ea29392d05f84ad3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f8a48a7575fd3a7663d52d8180eb79dd57bf6e3eb023e219e37154d090f2434"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d69d2206800629aa8bbbd55dea7eaf1de7f7eab184c2d7a9710ed1dbab96debe"
    sha256 cellar: :any_skip_relocation, sonoma:        "03f15872482060bac16579ab30629464671e3c399088450a913f7bdecef4b2e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cd8784a300e9c0e99dcbcd9e2b134f50ac1ad0cc01630c757d3e0e109220e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d373e40b7eee1502fa82f97f35ab5bba7d076c4a318282f4fbd627152893fe6"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    features = "default-no-update"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-nextest", features:)
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

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end