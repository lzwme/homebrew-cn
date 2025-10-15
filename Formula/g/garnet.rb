class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.85.tar.gz"
  sha256 "e6a2fcbc6f90e3d870a5a72633acb9a47e3c95071d1cdbfc1a7d4c38a222b0e1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b56f53d5f86eba96b927787b51bba626cb0e14427ffdc43b18a4e9e76912350"
    sha256 cellar: :any,                 arm64_sequoia: "7875c321cfa3b8cb55c7d95a40d406c55a70df120604757a83698e5beae55df2"
    sha256 cellar: :any,                 arm64_sonoma:  "661d53bb460876fe94db7d4ce98b9ff1582f7b46bec08441ced839bacb2be327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5a446cb7e68cd15abd4f48b09e753ae6e71dbe7fccea8d4696a4f9b60d68774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6fca09b146f5750cae2320787aaf0774db8f89b59fca623c323c430520bf32d"
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