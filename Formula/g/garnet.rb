class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.90.tar.gz"
  sha256 "b0be0a834b1407362514c23cc45dd1af74097a39ce5d7ff170c04d9dedc42ee9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7243e0bafc9611f47af9e70007cd8e9873dad8309e27cbf98f16265a2c1cb2a6"
    sha256 cellar: :any,                 arm64_sequoia: "ff1802e150c8591af45b7bf593137e532d3a0c00d3c678bfc6f2db762ea91e4c"
    sha256 cellar: :any,                 arm64_sonoma:  "b08f729aeb3bda990adc160d8bac09379fab0afd0cb57208e5a92c14bb2c2ef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e588729f5974a14b9fb4105a3b6e4afb4ddb558647d96a78e51c5f9753cab5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d8b7b3318b6abd87bfeeb214cf5d5691c7f0375d848dba010623f208504a60b"
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