class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  # Check for dotnet 10 support on release updates
  # https://github.com/microsoft/garnet/blob/main/Directory.Build.props#L4
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.94.tar.gz"
  sha256 "695a978865a175a2503fae0e93f5045ce2a65386e91f005031924abf90596979"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab1b3dce7bc85bec254e04c8b0711ae8c14d991c62059e8c1301645abaaaed7d"
    sha256 cellar: :any,                 arm64_sequoia: "105c286172216b397b461b8abe39fc8e7c8aa9c614c52e7be6c3a67be597e400"
    sha256 cellar: :any,                 arm64_sonoma:  "328c46b12961a4a1b2876ed3b96f021235112cfa98ef92631178b127bed7fdbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fca653a7a94bea5bb893160e94bf6f2faff94ab7e9be0dc591ba529fa199fc67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "393532dec2a43a840c1ca303b745bf81538b567286a86c49b5124c13fb256ddb"
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