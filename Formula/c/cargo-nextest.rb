class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.76.tar.gz"
  sha256 "8cbb0dd192d6e5e13af06cefc03042e53a41e0c66a57276d134b4b6890b79e66"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47c3e2c87c448a7d7e3d1b01389de3bba21322ea38647708bcbd1e6656e8bec4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cb1f825fb03676f04efbea6094161e7ec2c879fc00bb46cc29a0047bd4f2283"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f824f49d46e03557236617f6ea67ef6b873e6cc793a7e593b84e09915879701"
    sha256 cellar: :any_skip_relocation, sonoma:         "22fe2346fd12502797fee32030de14b819e2e6c0b666307aeb97b809bf55f2a7"
    sha256 cellar: :any_skip_relocation, ventura:        "8cf98fb44bac9b6b6fc3d35e0828c0597246bd5eb30c419f4bb6e27416116120"
    sha256 cellar: :any_skip_relocation, monterey:       "43543999341889ac8c5b7a19c1de75b9e6cb49c39748d2b35e236cfb02082d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e6c24f16eacebefce4008a5f67ff9362bb926458cc651add72a1b29275ecac1"
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