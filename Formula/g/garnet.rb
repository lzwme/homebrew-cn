class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "88a37a72820fa7009df212c6c3d59a1751a123dd5f8e6a69ea8bbc5359de8b6c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5568117bd748052dacfb5f22a63d64cf1c920c746d73ad6ebaf585c1d300c1a"
    sha256 cellar: :any,                 arm64_sequoia: "096e7f7c58f92f7f178c30bffd0dca45ed4ceaaa4757c508365446e305f82cf2"
    sha256 cellar: :any,                 arm64_sonoma:  "bb92977a2b02727c27cb574852cb6a1e9dbf8adcd2f8a0afef28a1f34c900dcd"
    sha256 cellar: :any,                 sonoma:        "6f70f5c4dc43db7d4a6b5d9ce3eee62ca68a9a2a98812fe38e6e921af020513b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beea2743074d51580a0ac4b61cfa21947114fce3a3227ddfeb5cd9be35853366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "746cd3a245531148278d558fbda27393c51d908a6debef50b5ae8062bfb93223"
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