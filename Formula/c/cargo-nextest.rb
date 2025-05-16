class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.96.tar.gz"
  sha256 "791e42ea5a5fe6c42713f68e7dab8a9bb769c7e38336262b9ae8d226631d95fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1df24128be0538c2c92a37c49659221b5e5e6a8e00c0435b9cbe9cc130802038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3577773a71290304c818acf2336edfdce9d795adb7c2f87df15f2183246543"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58b329265f415c35f41491a160e14c20bcf1573009d8217d93570f61ac70413c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9525c10ccb3f00e11c8a89d8c7d0f0c4cfe48c734a6196ab4ec2a87a76474f5"
    sha256 cellar: :any_skip_relocation, ventura:       "30f1ad4d3a71b68ae6e555ded63f2a1904bbfc693e077c6f31b6142721837bc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d7380109a6afd95e56a6dd84556cc339f08f69dcb4c298eebcf7874276baf60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da88a7d5d7c14fca9424ca38651dedc85f3dec4005ce331f9c64ded9daa17ba2"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

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