class Readpe < Formula
  desc "PE analysis toolkit"
  homepage "https://github.com/mentebinaria/readpe"
  url "https://ghfast.top/https://github.com/mentebinaria/readpe/archive/refs/tags/v0.85.tar.gz"
  sha256 "2747a3ee87c7fb1ed0a13242816752a94603adb6ae0d9f507b019ac582c394eb"
  license "GPL-2.0-or-later"
  head "https://github.com/mentebinaria/readpe.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "f98b2e4b55298db97d368ad4ccfe9f5dbe74286eab43d1e71b26d7043a9ba26e"
    sha256 arm64_sonoma:  "f29c0dba37afbad7e277e654f496dca1b0a46a43a482e313e4d6029b64cde131"
    sha256 arm64_ventura: "cdaf14255fe12a62de0aceeeaba0295d5473982f5a4de83e0d0c1c488fe13c1b"
    sha256 sonoma:        "06fdfb9de15adba67c1793252809ac31026b7a57c3f257a7ea9faa10d48407bc"
    sha256 ventura:       "9c79adc8221e526425dc76077514693106bed211decdeef14ce38651c661d03c"
    sha256 arm64_linux:   "73486c7e47dff8c7e522d2e153f99c78334f06c8e173d2934a3734aef18a4156"
    sha256 x86_64_linux:  "6174a21139b0e037802e51d54262fc2ad2ce5e4367d84ad38703d68daf11bdf5"
  end

  depends_on "openssl@3"

  def install
    ENV.deparallelize
    inreplace "lib/libpe/Makefile", "-flat_namespace", ""
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource "homebrew-testfile" do
      url "https://the.earth.li/~sgtatham/putty/0.78/w64/putty.exe"
      sha256 "fc6f9dbdf4b9f8dd1f5f3a74cb6e55119d3fe2c9db52436e10ba07842e6c3d7c"
    end

    resource("homebrew-testfile").stage do
      assert_match(/Bytes in last page:\s+120/, shell_output("#{bin}/readpe ./putty.exe"))
    end
  end
end