class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.89.tar.gz"
  sha256 "33f9a4d15d0a4ff268b723cff93b9a50e750e870783d468923c9a029c7f5ee29"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77b4bff80dad1b9ba735cef43b446724d5b14c437186655cff8ec4b631dd81be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662c7d68d3802b9319b8e3c3aa3470627faf8e3e97ecb4178e84b70444c61bfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c19d8ffacdcc5330e25a786355bd0918e2604a08a8dfc678789ebe93621e6e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "df3c1943731fa9e476a2aee14120eebac385543ba7ed87377da62dc30cf41982"
    sha256 cellar: :any_skip_relocation, ventura:       "bd04a1121006dee086cf951bf6ce63db6f4e8fd3b6a93e22c433338c2fb38744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1435e90c2a35c80cb0d2d78d259492ea271c0c2f42d594a00237b2f05cb5dd"
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