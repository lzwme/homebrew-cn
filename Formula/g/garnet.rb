class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.82.tar.gz"
  sha256 "5e70a30f8850283484b4283d803634fbeafd82f3b4ea008e0e7c61a254df643d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "081bf9cbd442a8f4620b47e66ff622074367d96f0c9e6fd3715142757a265843"
    sha256 cellar: :any,                 arm64_sonoma:  "53c08bf71a66bd5bedfa79168c0607d7a43a358af634977ac645ae328a3bc4fa"
    sha256 cellar: :any,                 arm64_ventura: "016d9bea190c2d8f133af523e5f741c520f2b7befb091d63c46cbc26a636017a"
    sha256 cellar: :any,                 ventura:       "8d32192db87e988b6c9768f13587cc2e21ecbb8f88a9ec0cd0794af50857f6f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1aef1575ea9d83922e1173ec8ca3389e50bd745755ba69a4852e7a33c0f9947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c296fc69f54006ea020f75ab3b78050cd91401e5408f20b9d7466ef92aef5d3b"
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