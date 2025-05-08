class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.64.tar.gz"
  sha256 "a53ba5e15ba30d869fb86223a14c6e03c5abcc55c49b1d8d9f1ee8af9de8ed61"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc8acce1bfc68f033834c969fe53509c6d4e2220b1467ba678167b3357a65ef1"
    sha256 cellar: :any,                 arm64_sonoma:  "195af6f5ac81375f8b17ecb43d6c1782542d7bbc24fa9bb008746ef1eaa70caa"
    sha256 cellar: :any,                 arm64_ventura: "bf5f070f224939b40ab5db8fe6fab7a0d263402820b82bea9cfc84d342d5d303"
    sha256 cellar: :any,                 ventura:       "8ccf8d9292aa12c11b3402a14aceca212d499cb3d3f420d8ff76fe60d701f2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d4e4f1551b1376f5decc5e924e985d190053ec1afd86406c45da73fc718e20d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe880960f03e6a815cf032dae2c54e7771a06c0e26e035abf0a609beeea365ac"
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