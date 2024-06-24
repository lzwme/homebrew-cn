class Nsync < Formula
  desc "C library that exports various synchronization primitives"
  homepage "https:github.comgooglensync"
  url "https:github.comgooglensyncarchiverefstags1.29.1.tar.gz"
  sha256 "3045a8922171430426b695edf794053182d245f6a382ddcc59ef4a6190848e98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e26d4118f7cc103d115354063badfaaacb688bc4f062ce8a1bcabe0e931db7b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c5f9305a3cb9b6a55b79b5adc122b5fd7cf30006b759c31df99f44376416f4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bece1cb9c8c2f20eaad4334b06ac302de5f6ae681555c00cb9cf7c8f11cd307a"
    sha256 cellar: :any_skip_relocation, sonoma:         "43d08a39236f457c376c52c24e9e756465177b0efedda2b26a871ac933082800"
    sha256 cellar: :any_skip_relocation, ventura:        "3b97786bc28199bad573f7be75b0172d54ac3d0f002cf620838814d14ea9f8da"
    sha256 cellar: :any_skip_relocation, monterey:       "3421d2bf00a82dc25a91626f290cf18477044516426e4b96cd5580ff4d4c1f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c86b79bf451db5a5e1744cbae4903610519a06ad644b1cb8ed7e3f4dbd5bf0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "_build", "-DNSYNC_ENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <nsync.h>
      #include <stdio.h>

      int main() {
        nsync_mu mu;
        nsync_mu_init(&mu);
        nsync_mu_lock(&mu);
        nsync_mu_unlock(&mu);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lnsync", "-o", "test"
    system ".test"
  end
end