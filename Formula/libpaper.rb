class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://ghproxy.com/https://github.com/rrthomas/libpaper/releases/download/v2.0.12/libpaper-2.0.12.tar.gz"
  sha256 "43b6af8250f1ebd93e7673a6c6cfc5835b42877bcd2960b4fb499a262f5f42e8"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "7409516c3bf53b504b13e0ba8fd04405f41adc4b1cc0227ce94bd470522a60fb"
    sha256 arm64_monterey: "5ea06bc59e0da2dbd9e00dc0e3513fa9b49ee6a65a96c6473680bb92fc545036"
    sha256 arm64_big_sur:  "55a3b814d78340448d45029960c62b5ac242dbb9fb2809785e6d3a37259cbc12"
    sha256 ventura:        "74bee9404d902b6f5f6811cc0623674799dff0c4501b19b20d55273751f9c8db"
    sha256 monterey:       "f0ccd197f540b9de99a5ead1b35a765b496bfc018cfef02d812eb05ab4658af7"
    sha256 big_sur:        "45d5d4185a32479aae0e3314accb5904810b606893b96c43663c6eb738a4c6b7"
    sha256 x86_64_linux:   "30b93f9ef8916267ebee6045a354b0e4a3fca8c36804e41b101b4754c188705f"
  end

  depends_on "help2man" => :build

  def install
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    assert_match "A4: 210x297 mm", shell_output("#{bin}/paper --all")
    assert_match "paper #{version}", shell_output("#{bin}/paper --version")

    (testpath/"test.c").write <<~EOS
      #include <paper.h>
      int main()
      {
        enum paper_unit unit;
        int ret = paperinit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpaper", "-o", "test"
    system "./test"
  end
end