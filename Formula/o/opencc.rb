class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https:github.comBYVoidOpenCC"
  url "https:github.comBYVoidOpenCCarchiverefstagsver.1.1.8.tar.gz"
  sha256 "51693032e702ccc60765b735327d3596df731bf6f426b8ab3580c677905ad7ea"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "4f1564df0e7b2080ecdaa4d861a6ead9eb2a78f21b9dd4146e9168b3ae4cd079"
    sha256 arm64_ventura:  "1a40b415517d09527c7536a9251829122fcb8de4d79a7ee589ff6e0dad508033"
    sha256 arm64_monterey: "3e99a5e151fa2372aae145f781bcf63991d2dbbb6c0e34a1973c0d67e659d0cf"
    sha256 sonoma:         "2358c0eacfbf766f35b97aa3b63cb1a28982b2578e87fb0113a648ac599d1102"
    sha256 ventura:        "efd4fd8db76a7892b3789ffde36502c2c7e4137083d588b5d71db0e921127d7b"
    sha256 monterey:       "bb99a57b146719effef5770b139ae5a1e5b9445eea79eac64a09cd443b5e1609"
    sha256 x86_64_linux:   "a479bf16d14166ca17d4db3b4dd3c5778d7dea4f715465b7c6d4b6490563b14e"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = "中国鼠标软件打印机"
    output = pipe_output(bin"opencc", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end