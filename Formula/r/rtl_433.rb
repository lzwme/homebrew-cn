class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https:github.commerbananrtl_433"
  url "https:github.commerbananrtl_433archiverefstags23.11.tar.gz"
  sha256 "1260c58400bf35832ac1b76cb3cccf3dc1335ffa2416909c63c7d7060c74663b"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.commerbananrtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "abecb01e4de144058b3db8eac1c0d6fcd16994f43e97ced92ac43cdc47f0a218"
    sha256 cellar: :any,                 arm64_sonoma:   "71a64b3bc46e45f9544e4b2c764c2cf329f4965b59701e897521aa3b53a117f8"
    sha256 cellar: :any,                 arm64_ventura:  "12c177662b3019a2f15bacd8819eb3ca3b52c4540824c48536d947ecc0d8ab3b"
    sha256 cellar: :any,                 arm64_monterey: "f7ea74abe442aef36c1edcb15cd7d4d3ea13b4da8c7cbc48afbb1c997273f430"
    sha256 cellar: :any,                 sonoma:         "143e9c0e0dcbbb4a7bc71cc40f6e512abc5da84d64e42a5f2fc7fb47c398af05"
    sha256 cellar: :any,                 ventura:        "a9064756df95ef0d25eb9f568c5f581e35692300aa9c1356af3fd18a5e491863"
    sha256 cellar: :any,                 monterey:       "c12dacc2821a946d1418483cd3c01c2818535111077357ae7668e9f5ce5c7ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86592dfc6a02ae7867d13268f978d45ee86a762eeb4673a21dcf4c60fe466929"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "librtlsdr"
  depends_on "libusb"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_cu8" do
      url "https:raw.githubusercontent.commerbananrtl_433_testsmastertestsoregon_scientificuvr128g001_433.92M_250k.cu8"
      sha256 "7aa07b72cec9926f463410cda6056eb2411ac9e76006ba4917a0527492c5f65d"
    end

    resource "homebrew-expected_json" do
      url "https:raw.githubusercontent.commerbananrtl_433_testsmastertestsoregon_scientificuvr128g001_433.92M_250k.json"
      sha256 "5054c0f322030dd1ee3ca78261b64e691da832900a2c6e4d13cc22f0fbbfbbfa"
    end

    testpath.install resource("homebrew-test_cu8")
    testpath.install resource("homebrew-expected_json")

    expected_output = (testpath"g001_433.92M_250k.json").read
    rtl_433_output = shell_output("#{bin}rtl_433 -c 0 -F json -r #{testpath}g001_433.92M_250k.cu8")

    assert_equal rtl_433_output, expected_output
  end
end