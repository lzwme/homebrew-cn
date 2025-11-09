class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.10.0.tar.gz"
  sha256 "998e717419c02ee735aea0b8d57f9cbe1112f40f4b947a39ba2611a415b64da0"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c3aaeddf8f8934b09b08b2a359a4611865a0e6f83dc7d6c517703175a99ad19f"
    sha256 arm64_sequoia: "87e75f64f8932d04be607d5a0462c5418ac621319662e3cd0f44b4f5ec669a7d"
    sha256 arm64_sonoma:  "954f8987dce436e2cca880e4633946056e9e79aac8ba1c56447499e3b6030b17"
    sha256 sonoma:        "a8fad2d9c503fe4e91907d91dd867c0bb6654fb1e47cd74d24ceb8ef6280859c"
    sha256 arm64_linux:   "fc8b5d062ad2c5503baa7203b52e421bb9fdc940c8bdf88c4697a5abd28559b6"
    sha256 x86_64_linux:  "6d634c0df3961d8cd48078a65df14792a5d1f440710efe112846e8aa905e448c"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end