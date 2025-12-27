class Libcpucycles < Formula
  desc "Microlibrary for counting CPU cycles"
  homepage "https://cpucycles.cr.yp.to/"
  url "https://cpucycles.cr.yp.to/libcpucycles-20251226.tar.gz"
  sha256 "5dc17b801b9b27f3861aab0e1754285b1703bffe9b8f469dc666de6d9be2f93f"
  license any_of: [:public_domain, "CC0-1.0", "0BSD", "MIT-0", "MIT"]

  livecheck do
    url "https://cpucycles.cr.yp.to/libcpucycles-latest-version.txt"
    regex(/^v?(\d{8})$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc7548e7fcfc557a5101c15d1b5fc6ddcfb17d0b7510c9c96c4d584b123da9db"
    sha256 cellar: :any,                 arm64_sequoia: "c2c0ac07f059d701198ae2f192321ea28d976947697cd94ae7cbcfa2706fed7f"
    sha256 cellar: :any,                 arm64_sonoma:  "e3eb9c855917b802fc34e6f55ad86fbb95d82a900ae99ca686df58301b160148"
    sha256 cellar: :any,                 sonoma:        "2fdeebd3792e2c38d244c265baf8c8716320ce637469bd0a99bbdd2fc62a4861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daa822e85793a60d0a237a9a16f87b4be6be61fd6801b3f60804b176b02caf32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9534e15d4eef0d7b5c16dd359f36e489e72512cd463a1019fafd960de87e0a55"
  end

  uses_from_macos "python" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <cpucycles.h>

      int main(void) {
        assert(cpucycles() < cpucycles());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lcpucycles"
    system "./test"

    assert_match(/^cpucycles version #{version}$/, shell_output(bin/"cpucycles-info"))
  end
end