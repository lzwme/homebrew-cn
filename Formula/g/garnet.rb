class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "c9fd5a00bdc36c0494189677c1220ef13f8db478a789609281725cca33ae7b70"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c6c76cab271195e74aed7c12a78f8036fb45dabb3313ff59a5b5d214048e111c"
    sha256 cellar: :any, arm64_sequoia: "dd62e69da5e9584aaf021bdd60eecdb023442f5c679e64a7398e8d27bf208e7c"
    sha256 cellar: :any, arm64_sonoma:  "386911e4978beb6707e9adb930ed906a1ad873b6a055d3fc1b3b4160e58a7eb5"
    sha256 cellar: :any, sonoma:        "4c690e36849ca288d76576faddcea432de1ec162bc3c257a0c8ef836f86d3ff2"
    sha256 cellar: :any, arm64_linux:   "5e1ab4b107fdbb209b2bd846ed212f7539bbd90e27fae79bfbfa77166a6d2157"
    sha256 cellar: :any, x86_64_linux:  "05cbdfd4bf55e6ba8cdf029bf49531bb9210177dd6a4f99a9771ea53c63a45f3"
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