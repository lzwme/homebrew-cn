class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https:microsoft.github.iogarnet"
  url "https:github.commicrosoftgarnetarchiverefstagsv1.0.71.tar.gz"
  sha256 "25fc5864027cf41c9956e594d437b41696f5a1c0bb89e71a60c31525f0a844ea"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "86e5d9c0d30c4e0b7c7f12ac579a8f4e8aeca42357ce74c7afd5f94977c798e8"
    sha256 cellar: :any,                 arm64_sonoma:  "10ef9950ac0dad6d93977d9f935ea31e91d062e5be2b5f0e1705090c3b7189c8"
    sha256 cellar: :any,                 arm64_ventura: "c97f6acec2b7737668b130ab911bd8614821454e51eb6982e59ccf6885ef0b13"
    sha256 cellar: :any,                 ventura:       "a8aabb53314c71286c16e21d6c8cc259361ad735a8f78d954fcd4697b25c67c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e4fcbaab4e7c4407f6e57aeb093d44f45b66d9c2d73897111fa0cda9d86b30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e2cdcb680646384bb16ebe73288f9790a13e19e0793e3ad16f31676e19b60c6"
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