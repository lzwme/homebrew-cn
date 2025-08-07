class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.80.tar.gz"
  sha256 "1885d47fd1cba043cd11bf8f4dc775cf9249f39b61edef11f3e0793b5e70f061"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55a825f373f9b39cde676fbc32473ac6aa3de40280f0b4059eab4e51f050831c"
    sha256 cellar: :any,                 arm64_sonoma:  "ad9328b092d5ce3f6db532eea2c37c94b13bf5459e24bc3e20956c79ff95ad2e"
    sha256 cellar: :any,                 arm64_ventura: "29fb6d9d539092a37e124fc4d9988cadbdb317221e1f5c2c66c765dcca7f4a31"
    sha256 cellar: :any,                 ventura:       "795c2687e79bcd2d98f8c6039a712434125d212b1647f9fa6453df358ab54e7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "900193e0ea16aa0978f6e1e66c4b5f2119e50b7a439d7c1c3fe0779520f83a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c09752f2c2057b097f574734c3dd85a8533562f1c06985f73d9593059e0736a"
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