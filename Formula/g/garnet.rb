class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.75.tar.gz"
  sha256 "2f20c00822845ac24dd5df1a3a301a1025200494b262c315022aff09d6c4fee7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dcb922d3ed854726ce28b97b65dd120f70508ca313f3bd1c75520be2683fc69b"
    sha256 cellar: :any,                 arm64_sonoma:  "32bf94c6391d4ed7c324cd21ed0d9b8ce779925d9ac51f5c1c8456f5ca258e51"
    sha256 cellar: :any,                 arm64_ventura: "990246dc0c79b6757b122fbf0f619aff0a458545e9498e5dfd7de2caf005fc93"
    sha256 cellar: :any,                 ventura:       "970f42d5e3bde0ce54c89da1bb7226fe925527e8f61aad6c2c6f292a8494c5a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68921d32c712f06a8e599ac3c570d905762dff8745b1c27b1e03a0ddfc09a2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05455c8273584a2686ae28ba9cc290c450833f3062bf2b9d5f0bdc711c6356d4"
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
      cd "libs/storage/Tsavorite/cc" do
        # Fix to cmake version 4 compatibility
        arg = "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        system "cmake", "-S", ".", "-B", "build", arg, *std_cmake_args
        system "cmake", "--build", "build"
        rm "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
        cp "build/libnative_device.so", "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
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
    system "dotnet", "publish", "main/GarnetServer/GarnetServer.csproj", *args
    (bin/"GarnetServer").write_env_script libexec/"GarnetServer", DOTNET_ROOT: dotnet.opt_libexec

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      exec bin/"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{Formula["valkey"].opt_bin}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end