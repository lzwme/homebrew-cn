class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.0.79.tar.gz"
  sha256 "a3f005ff5154a7a058e579b134f117d559ac98f035804a0f1258ffdda4b2e563"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6ac9494d2aa5166bdb01566a8ead3294db6bbe4c824bfa2b58f9bfea19b77db"
    sha256 cellar: :any,                 arm64_sonoma:  "60e8941cacced109e172e017f15b06997d312fbf6d9440c5ea27ef6ba78efcc3"
    sha256 cellar: :any,                 arm64_ventura: "e0d8e57595e0d6139ccfb0535540911cbe911c63ac8c8347db3f2bb71334ad1b"
    sha256 cellar: :any,                 ventura:       "00c3a23983ae907efe2409793e89d239edaf0eabd82a4f251d3fcdb4cecc3f78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73d77e9d1c1c468758b37372bd896a7cf863902502283a0542e6ed2d545666db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907f90db5c8423c730c3b4e1f64550f0d3f31e8d42d3e7f101b5db89e453e85e"
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