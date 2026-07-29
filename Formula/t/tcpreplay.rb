class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://ghfast.top/https://github.com/appneta/tcpreplay/releases/download/v4.6.0/tcpreplay-4.6.0.tar.gz"
  sha256 "30f73b901e74b6ffc36c0f82afccc9d5740e70ba214a15763631a59dd2cc3564"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "80a6c8a77f1050deaf21d4db78b016d07b9489fe45bfdb93a9ad6b97c73963f0"
    sha256 cellar: :any, arm64_sequoia: "264c0b92bf7438cc3a79e2e3a6fcb933f61a30fc79c0908bbf0eb32eca40293b"
    sha256 cellar: :any, arm64_sonoma:  "7bb2ffb6bd1df14490238187893217af35679c83f4a1869f75cdc4c7720f92fd"
    sha256 cellar: :any, sonoma:        "b9578dba4e2bfeb0c3150c05693f09f88e10d22409bb3a01f4a11633732d6c7a"
    sha256 cellar: :any, arm64_linux:   "499f089725023d55db3109b8dffeb2443c85a25a3e14b1cf0231c8235404d131"
    sha256 cellar: :any, x86_64_linux:  "166c1ce3c182c9783942178a600f8a4c377ed15857bfd357d73d04d12957c592"
  end

  depends_on "cmake" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

  def install
    args = %W[-DWITH_LIBDNET=#{formula_opt_prefix("libdnet")}]
    args << "-DWITH_LIBPCAP=#{formula_opt_prefix("libpcap")}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end