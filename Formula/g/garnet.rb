class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.99.tar.gz"
  sha256 "0bf081209162f7895c15605339f0772c95d4c39545cb1f8893451756f5271576"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f97461f93f5e9247a27b3b7e5284e4970dff612b5e03ddf3d385be7bd97ab895"
    sha256 cellar: :any,                 arm64_sequoia: "0be62af192065fbcaa8fe427c15efdc8762a29e95be538459c0622170f016921"
    sha256 cellar: :any,                 arm64_sonoma:  "8377b28d169e9f9e397e08872d81ef896860ca9ffabbe4c81bf0346a79d3ba55"
    sha256 cellar: :any,                 sonoma:        "4648df0bc8c4a3e7f8756fa0329c33b6b329368e123d59c9b3f9be7417e6c0f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4854126c07832ba0c03812b31050db79968de176d167d6a9daed3385083ad9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3282349ef2f5bf62a071b14fbddf1469b3850b7fb37f083a92e707d182e1c48"
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