class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "4f4dd40af718199b26f97e4c136662a72e154658b0066a774476a492fc67c01f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ba9942cc336036c0d99da3728499b6614431ad4c7037c457adf19ff58e831a6"
    sha256 cellar: :any,                 arm64_sequoia: "baf09050f0dcbc465deaba72be0179ea2b688018570a649527c908e1c6a75bf7"
    sha256 cellar: :any,                 arm64_sonoma:  "de035737837612a98dc36124b45c7796349666c33e299122ca24b390a410edb3"
    sha256 cellar: :any,                 sonoma:        "ef7af77c8f13be9668b7fe8e8d1c9e60f39475e4a8401d4f869382892877cda7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d142170a9cc11ac9411782aa89ce8b212b0a447067ed0c9503ae24626323abf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "655ca948d59e7fc63979332cfd4bf6412393656fe12cd61af7f7f0637adfedaf"
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