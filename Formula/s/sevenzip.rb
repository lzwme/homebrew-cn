class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https:7-zip.org"
  url "https:7-zip.orga7z2407-src.tar.xz"
  version "24.07"
  sha256 "d1b0874a3f1c26df21c761a4a30691dc1213e8577f18ee78326c14ca4d683e2b"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https:github.comip7z7zip.git", branch: "main"

  livecheck do
    url "https:7-zip.orgdownload.html"
    regex(>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)\s+\([^)]+?\)im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b05d82402484962cfe0e5e0c979bb6fc638b5866198688db847e6239059e05b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f415f2eed462d1178abb38a0a86423bfc97e317efc3e62fd827eae639cdd398a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bfba9b031710ffa58befc04947dddb39f45bf2ec6e9ca700d9b666899b9981c"
    sha256 cellar: :any_skip_relocation, sonoma:         "28ba9a09837fec00daa083d5a63a204822d44e46bff7d9ab063b760942745557"
    sha256 cellar: :any_skip_relocation, ventura:        "07d25d1de1e5220aec2ac15dd91bf439873541a728199c5d51963dc3c7d55c73"
    sha256 cellar: :any_skip_relocation, monterey:       "8cb24df5e3b465203966432107c87feaebd104216cc50eaf831081e76c506c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ada311cc2dfe95891f06f392cc11f488e4cea5ff87e834a92edf258f96456fe7"
  end

  def install
    # See https:sourceforge.netpsevenzipdiscussion45797thread9c2d9061ce#01e7
    if OS.mac?
      inreplace ["CommonFileStreams.cpp", "UICommonUpdateCallback.cpp"].map { |d| buildpath"CPP7zip"d },
                "sysmacros.h",
                "types.h"
    end

    cd "CPP7zipBundlesAlone2" do
      mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
      mk_suffix, directory = if OS.mac?
        ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
      else
        ["gcc", "g"]
      end

      system "make", "-f", "....cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"

      # Cherry pick the binary manually. This should be changed to something
      # like `make install' if the upstream adds an install target.
      # See: https:sourceforge.netpsevenzipdiscussion45797thread1d5b04f2f1
      bin.install "b#{directory}7zz"
    end
  end

  test do
    (testpath"foo.txt").write("hello world!\n")
    system bin"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath"outfoo.txt").read
  end
end