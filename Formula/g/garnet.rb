class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  # Check for dotnet 10 support on release updates
  # https://github.com/microsoft/garnet/blob/main/Directory.Build.props#L4
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.96.tar.gz"
  sha256 "cf3f4ea50db7bc0d640bd869793cbaf9b8fc6485b2f34795c4943ed0971a2cb9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec97e3e5164fe73732d11991e89d304447400baceefbffc1f5dec9bff5455a10"
    sha256 cellar: :any,                 arm64_sequoia: "8a4cd7868b6e0013635f2a4fe2c2f26993aedf1a67676a09338db3675b6e6ee8"
    sha256 cellar: :any,                 arm64_sonoma:  "36627ca41eddffc0b85ef7ba0cea6731bcd3b01506d165b1d3d009618537d4d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43f6c527267b35087e57741c206bebab66eb0f13a1cf8a8579cfd7666460b255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71e78f1185b7ca48cdc3c308b6325ca7f01d9c4cfa0f53e89b1954b83dbd46e8"
  end

  depends_on "valkey" => :test
  depends_on "dotnet@9"

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

    dotnet = Formula["dotnet@9"]
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