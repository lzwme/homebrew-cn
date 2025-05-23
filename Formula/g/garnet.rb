class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.66.tar.gz"
  sha256 "bd0de868121205ade4e0e64afdc048a90ad070a256086231172f356edb038a59"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "874d49f05e246612663bfcce56fbeff9a7d80a2c18be0d4298c94ec346a83209"
    sha256 cellar: :any,                 arm64_sonoma:  "ee5655f21b302e8fea8c5eafc3c7234000f21f1f8e95ff55f8e5ba75954259fa"
    sha256 cellar: :any,                 arm64_ventura: "d4a8e29686b29708bbb20ac33ca90b77ddbec04114d78cab49d068b93ebb49b5"
    sha256 cellar: :any,                 ventura:       "47ad05a8a6f537a29d4a03c721cb2281bbedc656d375e98efc82a8c9c8d815f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b556921fa78014f731618d79135f52ae9e4eb19c0febdff414f9421e07160e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b50b1f9bc29c25fa196fd9bee3f520d5f0b590ef57430960e992ce2d06f8dfa"
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