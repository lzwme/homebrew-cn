class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "dea85632ec070c54c13b4b0fdc2d442136c43a7cdc6f626801eed3c9c1f2a7e8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b4710a954f2ac121d1d571b2e99c531e00510bd32dae479acf76d8fcf4e9577"
    sha256 cellar: :any,                 arm64_sequoia: "87bbee8ad22121792a50e6475290dee7e1bfb83c467304aa2eecca111b3801c9"
    sha256 cellar: :any,                 arm64_sonoma:  "bd5fe457b0fd19cf451a433c1d0fbc5dfe8a28641ca7a9856e5d79a84b465214"
    sha256 cellar: :any,                 sonoma:        "9e739b735a4af824256b3f57615c3bd0187a82b30c42af039046fb45315eb02b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42e1be3fe3890f505fb712a3a96bf16a11c1c8ed60142fa5bfcd3cf119533e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2189d1d1975f9785ef039f8cc924895e1233f81aed0784fa3c1f67ced0ea4851"
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
    # .NET 10 flags IL3000 here even though Garnet falls back to AppContext.BaseDirectory.
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:WarningsNotAsErrors=IL3000
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