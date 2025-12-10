class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.91.tar.gz"
  sha256 "18a6690341c944977ef909b76068669e179ce237d842fbe764df48f6963931a9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9de73832b4035e8e5a84127f3015cbe0b0fa6401332012c58bd65b921fb187f9"
    sha256 cellar: :any,                 arm64_sequoia: "e93003f24323e8a4e0f56258369b03f6be737f3af597950c13bd6f36c2577719"
    sha256 cellar: :any,                 arm64_sonoma:  "47772246726056bdd1e89d07982da2cc3af38d3dce607d381610811c0bdc17fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b9d4dde7a2049448bdab617b9a060d932741a4123c0953c59bf16381b884ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f650dd847522750d3eda1104af1a467abe826916f2f040a6547e29db9b3a1580"
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