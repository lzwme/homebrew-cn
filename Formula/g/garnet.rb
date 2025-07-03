class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.74.tar.gz"
  sha256 "1661c1767ba6d3b1f8129650e1bae972f1411be5c05025ef0c10daab73ee4758"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "788701530bdc30857adbb049732a0557ab88e7714d4a895bbe963fb40a39d960"
    sha256 cellar: :any,                 arm64_sonoma:  "c14f178e7a2d055d08bb763b7de8122ff1f68b56e39294241b7200a5bccad04c"
    sha256 cellar: :any,                 arm64_ventura: "3c776e001af21cc7eb5b4682374cec21582f6374e3b8e23457275b15480d9c2d"
    sha256 cellar: :any,                 ventura:       "74e661ddf1ef6c5fa4f4d7c46b321e49d5e29d0df281b404b477102ad6c86144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60d6d7cc10a5406b84916c2387630e1961eae353a422b9bdafb3c50c7ee0346f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3153996bf03fa81be128961b0231ed7e1b927071f8c8f1c46c80f3ee837aa617"
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