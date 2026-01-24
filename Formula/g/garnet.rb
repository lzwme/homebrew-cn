class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  # Check for dotnet 10 support on release updates
  # https://github.com/microsoft/garnet/blob/main/Directory.Build.props#L4
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.93.tar.gz"
  sha256 "3561d7b6c0508915ab33a3b470d18a4201a10712b7a16c626b29af9bb28e8e02"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eab9e7149cae2986393261d01d7dc4637fb8fc0214e9e3c8621b66413f353123"
    sha256 cellar: :any,                 arm64_sequoia: "0bece0253902b61f4e063a61466a0086a94d27eefed1f0891ac8b40ad7b6df80"
    sha256 cellar: :any,                 arm64_sonoma:  "f5116b8cad3a2c20784fcb521b0da72be81f36a3aa642446439810a85372e1b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8673e0a0de56cca287174baefa5da53ada7e10dfd94cf11ba398aca82cddadaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f78f4cba3ed79b39b24603e6c586e29afa90969768b7c2207cbf9c84adbf2a"
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