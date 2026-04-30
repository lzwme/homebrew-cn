class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "ba0becfb1a5e1fcf2d2f99e055588accce8a83758a88401190a1a8d5eef58e68"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2b9e6e0e31b0cb6be2e1cd7632e9480830ddc56eb14aa42cfd9eea4790e615e"
    sha256 cellar: :any,                 arm64_sequoia: "30ebeaa75a439f8e7c2bc685e061f794ccb2197926ea4399af969a14ea7497e5"
    sha256 cellar: :any,                 arm64_sonoma:  "fa07fa461428115532860763edba69f004efb3a1e6cfcfc20755722ef89e9df4"
    sha256 cellar: :any,                 sonoma:        "c2431ae7d81b01462ae6e8b987fa0fb7d3d2635c160a9fa7c5c790e43942b780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "470c78255bc0790b29a857f2a7763531db5998fecc5b60eb1c738b594791e621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e80fa0d95ee0ca24f4dded93a24ebdd4ae0e8cb640e3ac3bd142f989998f62d7"
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