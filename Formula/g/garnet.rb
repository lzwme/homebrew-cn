class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.70.tar.gz"
  sha256 "dc0c685bf4367f980dcb937484ee3e2ebc1d3daf9e7ae415f6d9b9e1abf18c4d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4185521545149911f449aaba3e42499f67f45437c0258d4d7ceba65845748715"
    sha256 cellar: :any,                 arm64_sonoma:  "3aff96c25aeb74f72eb5cf1eb20cc43af1efc836a61df5000a2dd93402f24378"
    sha256 cellar: :any,                 arm64_ventura: "f8f937fc80e33086a9978b8b0efa9eb3c56df84117f2529c657da99c87af8228"
    sha256 cellar: :any,                 ventura:       "a364561b66e0afb2f859cdfaf50a52228ada0551da13ad57a1826a7c98e89a21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ce287aee262734917c8846fcfe8834df6d7be8a351cec1690564290f3600a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ef85c31c928765ada98df75144c0c5ce4f79b4c6f3d63e99bafc0eeb838eaf"
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