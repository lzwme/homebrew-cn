class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.67.tar.gz"
  sha256 "d21821f60d5f410b16262e8ad7fc6d8638d23606f8f44612feed5bc5a7b70520"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3daade39d5c264f698b4373e0fa7fcb000ec0efc29addf6750d7c0753565a20a"
    sha256 cellar: :any,                 arm64_sonoma:  "dd67454645e1f2cb6f20fd984db364a2c5e55bff5d69882e19ac6b6d65a908c3"
    sha256 cellar: :any,                 arm64_ventura: "5fab68cb2bb0e2c8a2aa7229396c9fc5d3659894babb1bcf0dc98168ac08438d"
    sha256 cellar: :any,                 ventura:       "b1872f984cac6adf94fe87d76e4ee0d4055254f0974d897de82d67f43c92c125"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "229fbbbf353129656df86e1dca6ba2deb6e38e010bcc10ae20e622b23404fadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea0db3b3b5647bf9b53313ea78c421385dafe62cdf810e9d7aa307a6afe9c11"
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