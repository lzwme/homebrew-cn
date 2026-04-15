class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "525506d347ef668258c94b5b873ae88f090cb0c70b89e9f77d684fa10af4b194"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d43c5bbfcb158d56b4d07598b02a3ddccda1fb460a1251a1d51c5300337d4bb2"
    sha256 cellar: :any,                 arm64_sequoia: "45d3a4ffa8f735b27aed98d4969a8a0ac8e86f9a7882c723d6b525b0c1d39ee8"
    sha256 cellar: :any,                 arm64_sonoma:  "4755623b39eb551ad7e0869e5fc020ef81474ced018c44f5a3743d5cbf31a2c2"
    sha256 cellar: :any,                 sonoma:        "7e6b01d5a62c7bb9c3ce5579c9d166faad9f1c11c347e81928a09b0c99a11f5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a645acafdded692bf712db8853d79602908f4309ba65bd6bdd4202f51ad603f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a07cfe9c32ff60a2237976698f94041d816afe2f8e4d17af5d79c03f9cb030"
  end

  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

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