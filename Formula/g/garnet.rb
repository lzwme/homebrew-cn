class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.87.tar.gz"
  sha256 "3757b23826f849fa16729da9d328a1932970878b209f98086a4a7d37721bac77"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b226675adb139a0abfc80c8e47043b00c302fad49c46c4fa4e0d57940af451a"
    sha256 cellar: :any,                 arm64_sequoia: "f909134ffe7289c4983f92fdcd93d342ede1ea14ca40796f19031bf5dafbb6f2"
    sha256 cellar: :any,                 arm64_sonoma:  "c5c5af8736319e6aab139efc67b68dd8f57f9cef443b73c4d7c124a48170106c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2273afe3fd31def7a0786d06d4ac4c96c943fdd79f9e94a10d21cef645d4623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b1dcee75e2c1085ba431abd06f0d63d9093aa0994d5a25396581c93bc869763"
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