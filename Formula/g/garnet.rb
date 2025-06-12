class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.72.tar.gz"
  sha256 "4eb6d3df129d0f3dbf718678ada6f67c1315f19452fa08627bd5e2e654e440b4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4e06535b7d853c35d20bfdf0fdd672085e58db39c6b0f1c7cf963c53b90abd7"
    sha256 cellar: :any,                 arm64_sonoma:  "8b8f833ec07cea62b47c73c1ad0286976de83599dec5ebec7bbe27d7945e7ea7"
    sha256 cellar: :any,                 arm64_ventura: "feca476dcd18167d93cdad5c7f3628a3e5038c98bf8b6d4336293b85cc6013d6"
    sha256 cellar: :any,                 ventura:       "56a0fa83d5cfc7ffc8da7ec93feceb25704a9a1fcd319224574c54fbbb8f6305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b12bc6dbbfc8e07588a3eb1b4d53c6c60dc6455079b46633bfa58ad5a7863e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516b0008ff79c6ad7683d52ff02cc562aa72a2e12c710b0a22f87fd900d5ef7d"
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