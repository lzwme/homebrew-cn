class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.61.tar.gz"
  sha256 "faef1fac90b6479eb992ec9bec01e3dcff4bef164f425d96c4a10953b668868a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "375542189a7e911f51493bf2521c901f72688dd1bdeecf5367e4609923035669"
    sha256 cellar: :any,                 arm64_sonoma:  "ec98dfc633be8abdf9ac5a4ac45ec4c009a0ef63266f6f8680b641fc097b4525"
    sha256 cellar: :any,                 arm64_ventura: "b0e81a0695913eb8c1acc29f95cf63bba3698084a74cd9922f73117fad3fbd63"
    sha256 cellar: :any,                 ventura:       "6779306205af0efe53e18b00e5fcdde336c1273c96f5d7ed3f53adf57da2641a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f52cc4fcc79f9d8b1474da71d258305f27fb31b3614fa6a5aa8c5b63d991f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269ee8f334c463551dffbf5f05f86bc9c6ce3baf9b29bcf7db7b6cdcbfcb1bb5"
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
      cd "libsstorageTsavoritecc" do
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args
        system "cmake", "--build", "build"
        rm "..cssrccoreDeviceruntimeslinux-x64nativelibnative_device.so"
        cp "buildlibnative_device.so", "..cssrccoreDeviceruntimeslinux-x64nativelibnative_device.so"
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
    system "dotnet", "publish", "mainGarnetServerGarnetServer.csproj", *args
    (bin"GarnetServer").write_env_script libexec"GarnetServer", DOTNET_ROOT: dotnet.opt_libexec

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      exec bin"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{Formula["valkey"].opt_bin}valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end