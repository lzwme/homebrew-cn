class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "addb76d190d8702c332dd24c23e9d5ca992fd4a06f2b38ee5b4cb2acdfe75711"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d2ea1ca8b372c47e5f36e2e9b4008a2526ffd1e0a8ebf72ef3595acd81a67b84"
    sha256 cellar: :any, arm64_sequoia: "a4dc81676136f203556c68eb90191d82ed77f241bcb9595fb0b8c6b22b6e6622"
    sha256 cellar: :any, arm64_sonoma:  "900340ce58e5098a839d300fb94b5a0334382030713c8665098fb9b9fc0604c8"
    sha256 cellar: :any, arm64_linux:   "ee440a96560cf93b197c367d23617f7ffe5c1e6941c2e66aaff09e745557cf58"
    sha256 cellar: :any, x86_64_linux:  "7cecd2f26b59347804815f8b029daea8c120e680f915d4c29a13cc747ddc0b82"
  end

  depends_on "rust" => :build
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

    # Drop the prebuilt BfTree binaries; msbuild rebuilds the library with cargo and prefers its copy
    rm_r Dir["libs/native/bftree-garnet/runtimes/*"]

    # The device csproj ships every prebuilt runtime it finds, so drop the ones we can't use
    native_rid = ("linux-#{Hardware::CPU.arm? ? "arm64" : "x64"}" if OS.linux?)
    device_runtimes = buildpath/"libs/storage/Tsavorite/cs/src/core/Device/runtimes"
    device_runtimes.each_child { |rid| rm_r(rid) if rid.basename.to_s != native_rid }

    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        args = %w[
          -DUSE_URING=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
        system "cmake", "--build", "build"
        native_dir = device_runtimes/native_rid/"native"
        cp "build/libnative_device.so", native_dir/"libnative_device.so"
        cp "build/libnative_device.so", native_dir/"libnative_device_libaio.so"
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

    output = shell_output("#{formula_opt_bin("valkey")}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end