class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.97.tar.gz"
  sha256 "508b2d4783ae14ba77c9c98d0ed666326af5d7fd117bdf87c59c24da9b6591cc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0ccfe045a4b66d209bed0bfb1481d6320e9cde64a052aeeb0f722cb6943840f"
    sha256 cellar: :any,                 arm64_sequoia: "b4f6781b80bebe843b58b90db2f47d9a79bdeb8a7a5679e4fe8acfcc6bdacd5d"
    sha256 cellar: :any,                 arm64_sonoma:  "769ec911753b635462c471da08101aa56784695f1b81fa6e216ea91d8237c5e2"
    sha256 cellar: :any,                 sonoma:        "8507070165612054683f8e2e8c7dbfc2d64b6361d280d1f1ed540819157ec355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b12014db7c70937647d47825eb7ebacff460f0eb543f7e98e213dd2375b1d183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7bfff89c9a4a2a2f204dccf25f96b1a8d2672a3a217e17d3675b158e6bb6c5"
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