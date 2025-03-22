class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.60.tar.gz"
  sha256 "c9e4377f9996306d1eed9dbb5ba64306e99db2083cc43d32c2271d5a74e43c1e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e8aba62e2110a9e432dd7ac211878e88eb8ac6702c298488d1f4558481ff33d"
    sha256 cellar: :any,                 arm64_sonoma:  "afb58a797870ffe10fa64ab02f433fcdee5bee5e884b25428b64d829b1660f1f"
    sha256 cellar: :any,                 arm64_ventura: "218c20ae98f5513925497ae20208c3dc7db109ee1135d88c768f6c0b2e8f2286"
    sha256 cellar: :any,                 ventura:       "2671840549efec1b96e2c2925a00d9f6cd4326be8d1f157ee882d41092e39a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99420a3aeb83129340b5bab671176be4a7068f9fbde657f3730a0fd8320e7ff2"
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