class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.73.tar.gz"
  sha256 "2e64935f7a6f0542428c681b1978393cde78fe52115350a572c5eca40ad96f92"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e879b135c74fcbe721909be22dafa8ac3be168887dadb2ada70783cdb83cfe9e"
    sha256 cellar: :any,                 arm64_sonoma:  "36aba0cec388d1151aaab4518c73d5a4cc8e7456dd90b33406b382dc3b7bf889"
    sha256 cellar: :any,                 arm64_ventura: "24f409e4bfea49f099af7224379712b6af5a5cba6ac4961ef8f127bc45ffe59c"
    sha256 cellar: :any,                 ventura:       "73cf8c7d456ddbfd5c221d83de2f957f947baf1c1329ea5f33bffba229dca6ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c36013988bcf7006ee424cd2d7a93f9d4cbaa489a0046686ac4e1069a58c046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df8264f95194d21a98c2b5c2938ead66f59de67044897f1e0ad256a31a706dc9"
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
        # Fix to cmake version 4 compatibility
        arg = "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        system "cmake", "-S", ".", "-B", "build", arg, *std_cmake_args
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