class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https:www.srtalliance.org"
  url "https:github.comHaivisionsrtarchiverefstagsv1.5.4.tar.gz"
  sha256 "d0a8b600fe1b4eaaf6277530e3cfc8f15b8ce4035f16af4a5eb5d4b123640cdd"
  license "MPL-2.0"
  head "https:github.comHaivisionsrt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c7b2c84e165de83ce32e46bb6263158c2c9e680b816032d5b6771ccc6f32d7d"
    sha256 cellar: :any,                 arm64_sonoma:  "8e8f3ee4f8fdeb10602feb2fac3d140e236df5024e212fb6b6f1455bf2061532"
    sha256 cellar: :any,                 arm64_ventura: "806fa132d70ecfff69e3cecb0f4c70d8e994293e748ca21b7c30290c09e7db05"
    sha256 cellar: :any,                 sonoma:        "a32f1c565c530f10c2a9e1d943d0eacac64b129ba745a2eb6da520d574bd798b"
    sha256 cellar: :any,                 ventura:       "0d2f45e1447a367914e64e12d4039f7488a6c9675a2d8206abe65d741e553f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6e779a8068e881ea3977fd8ede3863b108f621589ee1f87a28360fd6d6ee257"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]
    system "cmake", ".", "-DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}",
                         "-DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}",
                         "-DCMAKE_INSTALL_BINDIR=bin",
                         "-DCMAKE_INSTALL_LIBDIR=lib",
                         "-DCMAKE_INSTALL_INCLUDEDIR=include",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}srt-live-transmit file:devnull file:con 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end