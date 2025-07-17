class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.78.tar.gz"
  sha256 "8af69d676a32bdbc06812caea1b43a82a0101716be13341ca91d5aacf2611583"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e620f6ae6137af627d28d35092307fd300571556e8dd80b49a6a8981ee41ae7"
    sha256 cellar: :any,                 arm64_sonoma:  "8b8b8c1a354b5ec302ac9f10b63cc0df3ff864417368b6490d9c6dcc6e718573"
    sha256 cellar: :any,                 arm64_ventura: "9bf4506ba333118889835d972a205a80b0403d78218cfcce5fd9536d34da2762"
    sha256 cellar: :any,                 ventura:       "4b5be9684d1c5cc68c355b7f9d7b422a6dd301b696af8b1fcb04410d8934600f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dc91cfd6a4d9e42e4d0887ebcbb59a33eb699e228444bf1d08306d52299ede2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14fffeb9d37cabd558b144309173a81f71aa1258be0e6dea8102186af72c7c56"
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