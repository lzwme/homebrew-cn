class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https:github.comgreatscottgadgetshackrf"
  url "https:github.comgreatscottgadgetshackrfreleasesdownloadv2024.02.1hackrf-2024.02.1.tar.xz"
  sha256 "d9ced67e6b801cd02c18d0c4654ed18a4bcb36c24a64330c347dfccbd859ad16"
  license "GPL-2.0-or-later"
  head "https:github.comgreatscottgadgetshackrf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "700b528a727979c136ce3c8c009ff76ed6683fa32236684847652da562bef92e"
    sha256 cellar: :any,                 arm64_sonoma:   "5bcb0c337a5f17808365a9472d8537f4bc91a7e16d0147656020a9e2c7fb8735"
    sha256 cellar: :any,                 arm64_ventura:  "785f40b5807a55615798acdb3c2f3084da4f619199ce4680dbdb03a33800e656"
    sha256 cellar: :any,                 arm64_monterey: "34c1393265906dce624d9ce369a051d119523f5c645f0ce651ac2fd3127101b8"
    sha256 cellar: :any,                 sonoma:         "0f6aad32f2fcec8733d6f1c6e2cd5454973a52c33f7797032a90bc9a730285ff"
    sha256 cellar: :any,                 ventura:        "d5620a9f49dd68c91a36ffb55c2b60c4a28baa5b98440e3425f2d0c35ce299b6"
    sha256 cellar: :any,                 monterey:       "b8fc89adc569dc32b152eafcea69a98d5fbe47264938992c5450048c392abcf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5305ace77af21dc264b7c83e17e95a89d05ef7f23e8af8cc29315728b340fbe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "libusb"

  def install
    args = OS.linux? ? ["-DUDEV_RULES_GROUP=plugdev", "-DUDEV_RULES_PATH=#{lib}udevrules.d"] : []

    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "firmware-bin"
  end

  test do
    shell_output("#{bin}hackrf_transfer", 1)
  end
end