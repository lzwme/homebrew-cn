class Nsync < Formula
  desc "C library that exports various synchronization primitives"
  homepage "https:github.comgooglensync"
  url "https:github.comgooglensyncarchiverefstags1.28.1.tar.gz"
  sha256 "0011fc00820088793b6a9ba97536173a25cffd3df2dc62616fb3a2824b3c43f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53f2cf85e2100cddd876d48d8dc6309daa08cd0867d603a6c0b658c0f295c893"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f12bfbc372ffce6a7888a33cc6aa4b530555b2599e78308945155fc4e11a27f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca0be2891d0afae87ab685a5e711e6866340aa7d61b56c8e2fe26a5876fe98b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f10dcc6b4e4505ad404dd34f56b1aa6ff7037f6379b7a7af5f3565a5d912438b"
    sha256 cellar: :any_skip_relocation, ventura:        "eb85df0493e20b08d1a46d81e668497487ba441e4b509df4486c6b5b2855ed4a"
    sha256 cellar: :any_skip_relocation, monterey:       "3c4acee3fe1279a69bff756fe73b3b88a6034c4a9a493c3377e440987869d144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d035281fdf1cc4be9a3d568c1a2aa6d25c0d3d10c8d5ae2403e1ad591da51a0"
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