class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https:tsl0922.github.iottyd"
  url "https:github.comtsl0922ttydarchiverefstags1.7.5.tar.gz"
  sha256 "c1334db016e8c05662adf45c450cb65ca101de14d0c6c2490212995f0422d73f"
  license "MIT"
  head "https:github.comtsl0922ttyd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "5129ca0f0391a5ddd3ca38cd40ba3645d34a6432d220a271fdfee3ddc3272877"
    sha256 arm64_ventura:  "08852f00644a783f0502427fac44711be05d62a76b8fa5e7f2fe82be756cc049"
    sha256 arm64_monterey: "b5eb994a632241a2733639672d76254a6a93c795157ce398b7f7b7243f4b87c3"
    sha256 sonoma:         "60bc7c8aac3a1cffa9629a407ccace7aa6e6a55cfa10ae499789b30e353938d4"
    sha256 ventura:        "575f7cb86b1c916821fb47d9f1ad74bfbdb4b5d41ece3079309929444a9e9d8e"
    sha256 monterey:       "6d2a1694b3ba8cf568a7e7c7f8fc88efe000d0be9a763dc1925e2496bfcd753e"
    sha256 x86_64_linux:   "0feca0dea0c77c912648caaebf3b6d787c6f2ba663a91e44f2db8aad4e5c3699"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-Dlibwebsockets_DIR=#{Formula["libwebsockets"].opt_lib}cmakelibwebsockets",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    fork do
      system "#{bin}ttyd", "--port", port.to_s, "bash"
    end
    sleep 5

    system "curl", "-sI", "http:localhost:#{port}"
  end
end