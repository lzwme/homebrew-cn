class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.65.tar.gz"
  sha256 "14031e65215dd2bd18fd861b8f5154773d06f00430403675626d9fcba93a03f3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d0a1d3e720cd16c4530b8d0c0945746050cd00c505e7f3eed0a0683b2afd8d86"
    sha256 cellar: :any,                 arm64_sonoma:  "b282882ede5263bde7e6c4bc640cf55303fa6979d7f03fa47ce7d05ba45e9b20"
    sha256 cellar: :any,                 arm64_ventura: "848513e725b102226f497cd533cde81b2b301696e6d10674f76d333cc540666c"
    sha256 cellar: :any,                 ventura:       "7f198f55ad233ff97304547b73d17ccef30ea40a862b85404ce2f7638e5b59e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b1e9d1fba0d1ae57e828617b25ad5e424e3be2864afbc054096b7aaab0e1286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f15a07f4363233e5d1d6e5066698cd2fdefeeee6a0e311cc79dd11be9955bb"
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