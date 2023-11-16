class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghproxy.com/https://github.com/mozilla/sccache/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "f7c5577743a0a28de1f425d337535b86e2523c738fae24eb7927af4e4a7651f6"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07000aaa7206ff4760d5d0a3f28d65fa19b59c38f2e3cc3c3dd7b494683a3a3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f22c8616a30b8135b07aab256d4e07ebd3b6c2c7e745d16635beaeeef4d90fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27debe02e3c728177b1237805782a9df1c90f3b9623895cdf30a4b2598f9beb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "772daeb923b801c1ffdb72377fc6b5dbd02b0a1cff542a220e285bc251398679"
    sha256 cellar: :any_skip_relocation, ventura:        "dc1c18d2829fde6d860524c073bbacb80a58f20247623a9fe16f3a59ed23201a"
    sha256 cellar: :any_skip_relocation, monterey:       "2a435eaa074b402dae5d6b300d5912477558fb96fbfa579ccacb80665cc40212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08be9ac67667734546149caf3a9d953a707bfa2af65498549c29b871b65ee2d4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end