class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.68.tar.gz"
  sha256 "724caa45c7e4e15ac37ca16c8e9f9b566a256bcf979af5133d0c805d5597a6e9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d7a85ade40f7eb9e69e6d77e2342ba5b54f4d09536bbfd9022e870259948ddad"
    sha256 cellar: :any,                 arm64_sonoma:  "f45e3ec4db237e603ead8651136af8c506d41ee77d583436843d937cd4fc7423"
    sha256 cellar: :any,                 arm64_ventura: "acee389c5d462bad0fecd3fed1aeccb5fe1a3c773bfb123cdbc1812fe1036b66"
    sha256 cellar: :any,                 ventura:       "e4296fe51ea245bbc35bd526bd584a3450c36520b6caa68795f79a9cc647b794"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac9d796d92f340f16cb06aa1da52d1114dd6cd2d59e73e5897407bd58fcfb563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b57ee719d6e49cf59ed2d6b4e3888534b572f3c39e346acda739d20e0bce5bc"
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