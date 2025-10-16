class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.86.tar.gz"
  sha256 "a88908a4456e88c6d3cee7ede59e16f1d3ac4b07671d64389b7aa5b04e4ec45a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2c37db0872d01cfd1a6806d3f4aee2681f9c39aa560244c212ca1049c5a8412"
    sha256 cellar: :any,                 arm64_sequoia: "d45b5fbb501bf3642e3af7bfdc79d848a438921e88551d2bf8953e97bf4e5aa2"
    sha256 cellar: :any,                 arm64_sonoma:  "18d9a0ba841038d1800e4e4a4ce3f26946104487266b664eb0b93f1e95da3e2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bc817e00cff853f7fa88739e7fd75eff68c6001a98b7460d2b9007152c652e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ab7f1813d4134f456ef045c72b08679a3cdbd5e1b8e4600aa1a3fe38b21c549"
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