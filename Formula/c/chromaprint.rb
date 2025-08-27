class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://ghfast.top/https://github.com/acoustid/chromaprint/releases/download/v1.5.1/chromaprint-1.5.1.tar.gz"
  sha256 "a1aad8fa3b8b18b78d3755b3767faff9abb67242e01b478ec9a64e190f335e1c"
  license "LGPL-2.1-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d074eaa951816006df71b92cf9b94151020a32f787b5ac0e60d7d8303e5cfd4a"
    sha256 cellar: :any,                 arm64_sonoma:  "85ad4051988d6609b4ad6a52da3bb0237698ec177562c91bdbe2c2567fdc3eb5"
    sha256 cellar: :any,                 arm64_ventura: "045e4296445d7df2b6ca92c7f38be54e6800b15b8f9f73f5096faa46cc80af65"
    sha256 cellar: :any,                 sonoma:        "ed813b567bc41715b232e3f6d0c60ceb8c14c578de63d5b0ab237f3a8cb6885e"
    sha256 cellar: :any,                 ventura:       "e741aaa28a560fd83e13f4d5af424b7b8b037dace190e7c20a752ebe866f19db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f11ec9c1500c4454e72b8e593cada9e2d45c5a7c83df7c45563cbc28440abd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8637d14ed163ba4bfcbabb76f53c33046945d33b3159c1d0e563369688a68902"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg@7"

  # Backport support for FFmpeg 5+. Remove in the next release
  patch do
    url "https://github.com/acoustid/chromaprint/commit/584960fbf785f899d757ccf67222e3cf3f95a963.patch?full_index=1"
    sha256 "b9db11db3589c5f4a2999c1a782bd41f614d438f18a6ed3b5167165d0863f9c2"
  end
  patch do
    url "https://github.com/acoustid/chromaprint/commit/8ccad6937177b1b92e40ab8f4447ea27bac009a7.patch?full_index=1"
    sha256 "47c9cc257c6e5d46840e9b64ba5f1bcee2705eac3d7f5b23ca0fb4aefc6b8189"
  end
  patch do
    url "https://github.com/acoustid/chromaprint/commit/aa67c95b9e486884a6d3ee8b0c91207d8c2b0551.patch?full_index=1"
    sha256 "f90f5f13a95f1d086dbf98cd3da072d1754299987ee1734a6d62fcda2139b55d"
  end

  # Backport support for CMake 4. Remove in the next release
  patch do
    url "https://github.com/acoustid/chromaprint/commit/1120d825d7d97668f9dc87768641ebe8c174907e.patch?full_index=1"
    sha256 "c3d5c86a4765e6f942a57bea245fb7f8fcf5ea69e2a4de2d2cd24e8e87cff9a0"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end