class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.81.tar.gz"
  sha256 "ec6824400e1266f832bdaf8e7e4383e21926bdd9b37ecd5bb70dcb95b1ca2bb2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f6d72cc04fa238e727a5213b2985619b83790754b5c0d3b8b89d0cdf70bb923"
    sha256 cellar: :any,                 arm64_sonoma:  "01b1644be437758627e981ec91410b7048ada43607e70422d9cef31b7bc7d4c8"
    sha256 cellar: :any,                 arm64_ventura: "7ae9fdfa700779e5826985509d60c2d280f7f9709c7c6502629b214c75d2076d"
    sha256 cellar: :any,                 ventura:       "5e50d0788ee681f10161e44474bd95825ac489ff3e929a62bfb5cba87bbcb39f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d441e7f299723bb31ce90db81e4f49f9ab7e28d2c11645660b795959d8c0b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a78c26eed3aa86964a6333c31ee6658d8e1a84258bc94cfb0bc794688da191"
  end

  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  def install
    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        # Fix to cmake version 4 compatibility
        arg = "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        system "cmake", "-S", ".", "-B", "build", arg, *std_cmake_args
        system "cmake", "--build", "build"
        rm "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
        cp "build/libnative_device.so", "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
      end
    end

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:EnableSourceLink=false
      -p:EnableSourceControlManagerQueries=false
    ]
    system "dotnet", "publish", "main/GarnetServer/GarnetServer.csproj", *args
    (bin/"GarnetServer").write_env_script libexec/"GarnetServer", DOTNET_ROOT: dotnet.opt_libexec

    # Replace universal binaries with their native slices.
    deuniversalize_machos

    # Remove non-native library
    rm libexec/"liblua54.so" if OS.linux? && Hardware::CPU.arm?
  end

  test do
    port = free_port
    fork do
      exec bin/"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{Formula["valkey"].opt_bin}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end