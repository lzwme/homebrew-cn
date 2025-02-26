class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.57.tar.gz"
  sha256 "f8332a6347ffb6836d4e8786242c8ac66b1422f5e1afa6c6cd3ef5f28085b844"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2c3df413d8223f1988e20045708047dd04b3761a7ceef3f59185db0f3d6d7f2"
    sha256 cellar: :any,                 arm64_sonoma:  "3c3f3d95ba9ecfec4f1366abe6cfc5b9b612c119d77a78f6b3db3d359905e246"
    sha256 cellar: :any,                 arm64_ventura: "3cf61e06bda4ab58b5caa8af1515f18b3e83c4fcdd96a3f21b0366d66aa5a953"
    sha256 cellar: :any,                 ventura:       "0e1a8d19cb138c7abd281bbcabaf522050be8d49c7016c40f6312f0eb6cc4085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5061ef2e492efa8ef38883741bf55fc85f0baa1a1a2403bc04c1dca79dfa3885"
  end

  depends_on "redis" => :test
  depends_on "dotnet@8"

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

    dotnet = Formula["dotnet@8"]
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

    output = shell_output("#{Formula["redis"].opt_bin}redis-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end